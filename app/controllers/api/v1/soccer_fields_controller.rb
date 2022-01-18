module Api
  module V1
    class SoccerFieldsController < ApplicationController
      before_action :load_soccer_field, only: %i(show update destroy)
      before_action :check_search_location, only: :index
      skip_before_action :verify_authenticity_token
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      def index
        @soccer_fields = SoccerField.order_by_field_name
        render json: @soccer_fields, each_serializer: SoccerFieldSerializer,
                      status: :ok
      end

      def show
        render json: @soccer_field, serializer: SoccerFieldSerializer,
                      status: :ok
      end

      def create
        @soccer_field = SoccerField.new soccer_field_params
        return unless @soccer_field.save

        render json: @soccer_field, serializer: SoccerFieldSerializer,
                      status: :ok
      end

      def update
        return unless @soccer_field.update soccer_field_params

        render json: @soccer_field, serializer: SoccerFieldSerializer,
                      status: :ok
      end

      def destroy
        return unless @soccer_field.destroy

        render json: @soccer_field, serializer: SoccerFieldSerializer,
                      status: :ok
      end

      private

      def soccer_field_params
        params.require(:soccer_field)
              .permit(:field_name, :type_field, :description, :price, :status)
      end

      def load_soccer_field
        @soccer_field = SoccerField.find_by id: params[:id]
        return if @soccer_field

        flash[:warning] = t "soccer_fields_controller.load_fail"
        redirect_to admin_soccer_fields_path
      end

      def record_not_found
        render json:
          {
            message: t("flash.not_found")
          }, status: :not_found
      end
    end
  end
end
