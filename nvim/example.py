import itertools
import logging
import time

from google.appengine.ext import ndb
from shared import db_models
from shared.models import api
from shared.services import text

LOGGER = logging.getLogger(__name__)
PAGE_SIZE = 1000


class TestClass:
  def __init__(self) -> None:
    pass


if __name__ == '__main__':
  pass


def add(x: int, y: int):
  return x + y


add(1, 2)


def merge_guests(event: db_models.Event, lists: list[db_models.List_]) -> str:
  LOGGER.info('Start merging...')
  start_time = time.perf_counter()

  # Get all the guests order by primary email
  guests = db_models.Guest.query(db_models.Guest.event == event.key).order(
    db_models.Guest.primary_email
  )

  list_priority_by_key = {list_.key: list_.priority for list_ in lists}
  list_sort_name_by_key = {
    list_.key: text.normalise(list_.name) for list_ in lists
  }
  list_wave_by_key = {list_.key: list_.latest_wave for list_ in lists}
  list_allocation_by_key = {
    list_.key: list_.ticket_allocation for list_ in lists
  }

  max_number_of_same_guest = len(lists)
  cursor = None
  has_more = True
  previous_email = None
  page_number = 0
  merged_guests_count = 0
  while has_more:
    page_number += 1
    LOGGER.info(f'Page Number: {page_number}')

    guest_current_page, cursor, has_more = guests.fetch_page(
      PAGE_SIZE, start_cursor=cursor
    )

    # If there is a next page
    if has_more:
      # Get the result from that next page using the max_number_of_same_guest
      guest_next_page, _, _ = guests.fetch_page(
        max_number_of_same_guest, start_cursor=cursor
      )

      # Create a list of guests from the next page only if they match the email address from the last guest of the current page
      guest_buffer = [
        guest
        for guest in guest_next_page
        if guest.primary_email == guest_current_page[-1].primary_email
      ]

      # Add this guest buffer to the current page so all guests with the same email address are process together
      guest_current_page += guest_buffer

    guests_group_by_email = itertools.groupby(
      guest_current_page, lambda guest: guest.primary_email
    )

    to_put = []
    for email, guest_group in guests_group_by_email:
      # If current email is the same as previous email then skip it
      if email == previous_email:
        continue

      previous_email = email

      # Create a list out of guest_group to be able to iterate multiple times
      guest_group_list: list[db_models.Guest] = list(guest_group)

      # Find the assigned guest where duplicate type is either Unique or Primary
      assigned_guest = next(
        (
          guest
          for guest in guest_group_list
          if guest.duplicate_type
          in [
            api.GuestDuplicateType.UNIQUE,
            api.GuestDuplicateType.PRIMARY,
          ]
        ),
        None,
      )

      # If all guests in guest_group_list is NEW
      if assigned_guest is None:
        # Get the guest with the highest priority list and update its stats
        # Priority 1 is highest, 0 means no priority
        # Filter guests by lists with priority
        guests_with_list_priority = [
          guest
          for guest in guest_group_list
          if list_priority_by_key[guest.list_] > 0
        ]
        if guests_with_list_priority:
          # If there is at least one list with priority > 0 then pick the guest
          # with the highest priority list
          assigned_guest = min(
            guest_group_list,
            key=lambda guest: list_priority_by_key[guest.list_],
          )
        else:
          # Find the highest ticket allocation
          max_allocation = max(
            list_allocation_by_key[guest.list_] for guest in guest_group_list
          )

          # Filter guests with highest ticket allocation
          guests_with_max_allocation = [
            guest
            for guest in guest_group_list
            if list_allocation_by_key[guest.list_] == max_allocation
          ]

          # Sort the guests by list name and pick the first guest
          guests_with_max_allocation.sort(
            key=lambda guest: list_sort_name_by_key[guest.list_]
          )
          assigned_guest = guests_with_max_allocation[0]

        # Update the new assigned guest stats
        assigned_guest.status = api.GuestStatus.MERGED
        assigned_guest.is_merged = True
        if len(guest_group_list) > 1:
          assigned_guest.duplicate_type = api.GuestDuplicateType.PRIMARY
        else:
          assigned_guest.duplicate_type = api.GuestDuplicateType.UNIQUE
        assigned_guest.assigned_list = assigned_guest.list_
        assigned_guest.assigned_list_name_sort = list_sort_name_by_key[
          assigned_guest.list_
        ]
        to_put.append(assigned_guest)

      # Update all new guests
      for guest in guest_group_list:
        if guest.status == api.GuestStatus.NEW:
          guest.wave = list_wave_by_key[guest.list_]
          guest.status = assigned_guest.status
          guest.is_merged = True
          assigned_guest.duplicate_type = api.GuestDuplicateType.DUPLICATE
          guest.assigned_list = assigned_guest.assigned_list
          guest.assigned_list_name_sort = list_sort_name_by_key[
            assigned_guest.assigned_list
          ]
          to_put.append(guest)

    ndb.put_multi(to_put)
    merged_guests_count += len(to_put)

  LOGGER.info(
    '\n'.join(
      (
        'Finished merging...',
        f'Merge guests took {time.perf_counter() - start_time} seconds to run!',
        f'Merged {merged_guests_count} guests!',
      )
    )
  )

  return f'Merged {merged_guests_count} guests!'
