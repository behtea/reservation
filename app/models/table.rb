# == Schema Information
#
# Table name: tables
#
#  id            :integer          not null, primary key
#  restaurant_id :integer
#  name          :string
#  minimum_guest :integer
#  maximum_guest :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Table < ApplicationRecord
  has_many :reservations

  belongs_to :restaurant

  validates :restaurant_id, :name, :minimum_guest, :maximum_guest, presence: true
  validates :minimum_guest, length: { minimum: 1 }
end
