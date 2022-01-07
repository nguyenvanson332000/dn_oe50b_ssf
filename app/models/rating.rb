class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :soccer_field
  validates :rating, presence: true, numericality: {only_integer: true}
  scope :find_ratings, ->{order :rating}
end
