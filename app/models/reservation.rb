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
  belongs_to :guest
  belongs_to :table
  belongs_to :restaurant

  validates :guest_id, :restaurant_id, :table_id, :guest_number, :booking_time, presence: true
end
