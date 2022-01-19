module Api
  module V1
    module Admin
      class OrdersController < ApplicationController
        before_action :load_order, :check_status_order, except: %i(index)
        before_action :check_search_location, only: :index
        skip_before_action :verify_authenticity_token
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

        def index
          @orders = Order.status_asc
          render json: @orders, each_serializer: OrderSerializer,
          status: :ok
        end

        def show
          render json: @order, serializer: OrderSerializer,
          status: :ok
        end

        def update
          if @order.update_status params[:status]
            send_mail_when_order
            render json:
            {
              message: t("booking.update_booking.update_sucess")
            }, status: :ok
          else
            render json:
            {
              message: t("booking.update_booking.update_fail")
            }, status: :bad_request
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
      end
    end
  end
end
