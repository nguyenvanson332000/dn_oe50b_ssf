class User::OrdersController < UserController
  before_action :load_order, only: %i(destroy update)
  before_action :check_search_location, only: :index

  def index
    @booking_user = current_user.orders.ransack(params[:q])
    @orders = @booking_user.result.status_asc.paginate page: params[:page],
                                    per_page: Settings.admin_order.per_page
  end

  def order_soccer_field
    JSON.parse(cookies[:soccer_fields]).each do |key, value|
      soccer_field = SoccerField.find key
      ActiveRecord::Base.transaction do
        ordered = Order.create(user_id: current_user.id, quantity: value.length,
                      status: 0, total_cost: soccer_field.price * value.length)
        create_order_detail value, ordered, soccer_field
        create_notification
        send_mail_when_order ordered
      end
    end
    delete_cookie_soccer_field
  end

  def update
    if @order.update_status params[:stt]
      flash[:notice] = t ".update_sucess"
    else
      flash[:alert] = t ".update_fail"
    end
    respond_to do |format|
      format.html{render user_orders_path}
      format.json{render json: flash.to_hash}
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      if @order&.destroy
        flash[:success] = t ".success"
      else
        flash[:danger] = t ".fail"
      end
    end
    respond_to do |format|
      format.html{render user_orders_path}
      format.json{render json: flash.to_hash}
    end
  end

  private

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:warning] = t "message.update_order.not_exist_id"
    redirect_to user_orders_path
  end

  def create_order_detail value, ordered, soccer_field
    value.each do |i|
      value_detail = i.split(",")
      time = value_detail[0]
      date = value_detail[1]
      type = value_detail[2]
      soccer_field.order_details.create(order_id: ordered.id,
                current_price: soccer_field.price,
                booking_used: time, type_field: type, order_date: date)
    end
  end

  def create_notification
    Notification.create(recipient: User.first, actor: current_user,
      title: current_user.name + t("notification.title_ad"),
      content: t("notification.content_ad"))
  end

  def send_mail_when_order ordered
    UserMailer.notify_order(ordered).deliver_now
  end

  def delete_cookie_soccer_field
    cookies.delete :soccer_fields
    flash[:success] = t "order.success"
    redirect_to user_orders_path
  end
end
