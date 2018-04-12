# == Schema Information
#
# Table name: reservations
#
#  id            :integer          not null, primary key
#  guest_id      :integer
#  restaurant_id :integer
#  table_id      :integer
#  guest_number  :integer
#  booking_time  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Reservation < ApplicationRecord
  include ActiveModel::Dirty

  belongs_to :guest
  belongs_to :table
  belongs_to :restaurant

  validates :guest_id, :restaurant_id, :table_id, :guest_number, :booking_time, presence: true
  validate :check_available_shift, :check_table_availability, :check_guest_number

  # before_update :get_old_reservation

  after_create :notifier_new_reservation
  after_update :notifier_update_reservation

  # def get_old_reservation
  # end

  def notifier_new_reservation
    ReservationMailer.send_detail_reservation(self).deliver_now
    ReservationMailer.send_new_reservation(self).deliver_now
  end

  def notifier_update_reservation
    ReservationMailer.send_update_detail_reservation(self).deliver_now
  end
  
  def check_available_shift
    shift = Shift.where(restaurant_id: restaurant_id).where('start_at::time <= ? AND ? <= end_at::time', booking_time.strftime('%H:%M:%S'), booking_time.strftime('%H:%M:%S'))

    errors[:base] << "there is no available shift" if shift.length == 0
  end

  def check_table_availability
    is_not_available = nil
    reserves = Reservation.where(restaurant_id: restaurant_id, table_id: table_id)
    reserves.each do |reserve|
      reserve_gap = reserve.booking_time + 1.hour # i set one hour for the gap      
      is_not_available = reserve.booking_time <= booking_time && booking_time <= reserve_gap      

      if new_record?        
        if is_not_available
          errors[:base] << "table not available"
          break;
        end
      else 
        if reserve.id != id
          errors[:base] << "table not available"
          break;
        end        
      end

    end
  end

  def check_guest_number
    table = Table.find(table_id)
    errors[:base] << "guest number invalid" unless table.minimum_guest <= guest_number && guest_number <= table.maximum_guest
  end

  def json_formated
    {
      reservation_time: booking_time,
      guest_number: guest_number,
      guest_name: guest.name,
      table_name: table.name
    }
  end  
end