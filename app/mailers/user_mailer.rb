class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("user_mailer.activate")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("user_mailer.password_reset")
  end

  def notify_remind_order
    @user = User.first
    mail to: @user.email, subject: t("notification.title_remind")
  end

  %w(cancel accept rejected).each do |order_status|
    define_method("#{order_status}_order_by_admin".to_sym) do |order|
      handle_send_mail(order, t("user_mailer.sub_#{order_status}"))
    end
  end

  private

  def handle_send_mail order, subject_text
    @user = order.user
    @order = order
    mail to: @user.email, subject: subject_text
  end
end
