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

require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
