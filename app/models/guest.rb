# == Schema Information
#
# Table name: guests
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Guest < ApplicationRecord
  has_many :reservations

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  # validates :email, format: { with: /\d{3}-\d{3}-\d{4}/, message: "bad format" }
end
