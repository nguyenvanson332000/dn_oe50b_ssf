class ApplicationController < ActionController::Base
  include SessionsHelper
  include CartsHelper

  before_action :set_locale, :set_search
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |_exception|
    if user_signed_in?
      flash[:danger] = t "message.cancancan.not_permission"
      redirect_to root_path
    else
      flash[:danger] = t "message.cancancan.not_login"
      redirect_to login_path
    end
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def set_search
    @q = SoccerField.ransack(params[:q])
  end

  def check_admin
    return if current_user.admin?

    flash[:warning] = t "application.check_admin.warning"
    redirect_to root_path
  end

  def check_search_location
    return unless params[:q]

    return if @q.result.any?
  end
end
