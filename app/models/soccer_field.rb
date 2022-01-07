class SoccerField < ApplicationRecord
  has_many :order_details, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :comments, dependent: :destroy
  ransack_alias :soccer_field, :field_name
  scope :order_by_field_name, ->{order :field_name}
  validates :field_name, presence: true
  validates :field_name, length:
                         {maximum: Settings.model.profile.name_length_max_50}
  validates :description, presence: true
  validates :description, length:
                      {maximum: Settings.model.profile.length_max_255}
  enum status: {left: 0, over: 1}
  enum type_field: {five: 0, seven: 1, elevent: 2}

  validates :price, numericality: {only_integer: true,
                                   greater_than_or_equal_to: 100_00,
                                   less_than_or_equal_to: 100_000}

  scope :search_name, (lambda do |pr|
    where("lower(field_name) LIKE :search", search: "%#{pr}%") if pr.present?
  end)

  def avg_rating
    if ratings.present?
      ratings.average(:rating).round(1).to_f
    else
      0.0
    end
  end

  def rating_percentage
    if ratings.present?
      ratings.average(:rating).round(1).to_f * 100 / 5
    else
      0.0
    end
  end
end
