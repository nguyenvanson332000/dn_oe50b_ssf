class Notification < ApplicationRecord
  after_create_commit do
    NotificationBroadcastJob.perform_later(
      Notification.unchecked, self
    )
  end

  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"

  scope :unchecked, ->{where(checked: nil).size}
  scope :sort_by_created, ->{order(created_at: :desc)}
end
