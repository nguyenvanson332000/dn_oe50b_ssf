class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy

  validates :quantity, numericality:
                       {only_integer: true,
                        greater_than_or_equal_to:
                          Settings.model.order.quantity_min},
                        presence: true
  enum status: {pending: 0, accept: 1, rejected: 2, cancel: 3}
  delegate :booking_used, :current_price, to: :order_detail, prefix: true
  delegate :name, :phone, to: :user, prefix: true

  scope :status_asc, ->{order status: :asc}
  scope :date_desc, ->{order created_at: :desc}
  scope :accept, ->{where(status: :accept)}
  scope :pending, ->{where(status: :pending)}
  scope :is_pending, ->{where("status = ?", 0).size}
  scope :find_date_accept, (lambda do |date|
    where("created_at LIKE ? AND status = ?", "%#{date}%",
          Order.statuses[:accept])
  end)
  scope :find_sum_day, ->{group(:status).sum(:total_cost)}

  def update_status status
    update_column(:status, status)
  end

  def update_order_new quantity, total_cost
    update_columns quantity: quantity, total_cost: total_cost
  end
end
