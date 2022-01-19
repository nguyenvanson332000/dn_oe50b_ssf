class OrderSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :status, :order_date, :total_cost, :is_payment,
             :user
  belongs_to :user
  has_many :order_details
  def user
    {
      email: object.user.email,
      name: object.user.name
    }
  end
end
