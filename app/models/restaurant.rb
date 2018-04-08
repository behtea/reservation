# == Schema Information
#
# Table name: restaurants
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Restaurant < ApplicationRecord
  has_many :tables
  has_many :shifts
  has_many :reservations

  validates :name, :email, :phone, presence: true
  validates :email, uniqueness: true
  # validates :email, format: { with: /\d{3}-\d{3}-\d{4}/, message: "bad format" }
  # validates :phone, format: { with: /\d{3}-\d{3}-\d{4}/, message: "bad format" }
  

end
