class Admin::OrdersController < AdminController
  before_action :load_order, :check_status_order, only: :update
  before_action :check_search_location, only: :index
  def index
    @o = Order.ransack(params[:q])
    @orders = @o.result(distinct: true).status_asc.paginate page: params[:page],
      per_page: Settings.admin_order.per_page
  end

  def update
    if @order.update_status params[:stt]
      send_mail_when_order
      create_notification @order
      flash[:notice] = t "booking.update_booking.update_sucess"
    else
      flash[:alert] = t "booking.update_booking.update_fail"
    end
    respond_to do |format|
      format.html{render admin_orders_path}
      format.json{render json: flash.to_hash}
    end
  end

  private

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:warning] = t "booking.update_booking.not_exist_id"
    redirect_to admin_orders_path
  end

  def check_status_order
    return if @order.pending? || @order.accept?

    flash[:warning] = t "booking.update_booking.check_status"
    redirect_to admin_orders_path
  end

  def send_mail_when_order
    return unless %w(accept rejected cancel).include? @order.status

    UserMailer.send("#{@order.status}_order_by_admin".to_sym, @order)
              .deliver_later
  end

  def create_notification order
    Notification.create(recipient: order.user, actor: current_user,
                          title: t("notification.title"),
                          content: t("notification.content") + order.status)
  end
end
