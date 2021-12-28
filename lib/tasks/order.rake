namespace :order do
  desc "use whenever send admin order notification every friday"
  task show_order_status_pending: :environment do
    Notification.create(recipient: User.first, actor: User.first,
                        title: I18n.t("notification.notify"),
                        content: I18n.t("notification.content_notify") +
                                  Order.is_pending.to_s)
    UserMailer.notify_remind_order.deliver_now
  end
end
