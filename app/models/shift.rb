# == Schema Information
#
# Table name: shifts
#
#  id            :integer          not null, primary key
#  restaurant_id :integer
#  name          :string
#  start_at      :datetime
#  end_at        :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Shift < ApplicationRecord
  belongs_to :restaurant

  validates :restaurant_id, :name, :start_at, :end_at, presence: true
end
