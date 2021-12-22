class NotificationsController < ApplicationController
  authorize_resource

  def create; end

  def show
    @notification = Notification.find_by id: params[:id]
    @notification.update(checked: Time.zone.now) if @notification.present?
    return if @notification.present?

    flash[:danger] = t "notification.not_found"
    redirect_to root_url
  end
end
