namespace :admin_notify do
  desc "Task notify to admin"
  task send_noti: :environment do
    if Order.pending.present?
      Notification.create(recipient: User.first, actor: User.first,
        title: I18n.t("notification.title_remind"),
        content: I18n.t("notification.content_ad"))
      UserMailer.notify_remind_order.deliver_now
    end
  end
end
