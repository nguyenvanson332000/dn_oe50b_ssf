class StaticPagesController < ApplicationController
  before_action :load_soccer_field, only: :show
  before_action :check_search_location, only: :index
  def index
    @soccer_fields = @q.result(distinct: true).paginate(page: params[:page],
                           per_page: Settings.paginate.manage)
  end

  def show
    soccer_fields = SoccerField.pluck(:id)
    @booking_used = OrderDetail.all_time(soccer_fields).pluck(:booking_used)
    @comments = @soccer_field.comments.newest
    @comment = Comment.new
    @rating = Rating.new
  end

  private

  def load_soccer_field
    @soccer_field = SoccerField.find_by(id: params[:id])
    return if @soccer_field

    flash[:warning] = "message.update_booking.not_exist_id"
    redirect_to root_path
  end
end
