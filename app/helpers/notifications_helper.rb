module NotificationsHelper
  def check_read notification
    notification.checked.nil?
  end
end
