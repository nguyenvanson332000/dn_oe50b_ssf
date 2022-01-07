class RatingsController < ApplicationController
  authorize_resource
  before_action :find_soccer_field, only: :create

  def index
    @ratings = Rating.find_ratings.paginate(page: params[:page],
                           per_page: Settings.paginate.manage)
  end

  def create

    @rating = current_user.ratings.build rating_params
    @rating.soccer_field_id = @soccer_field.id
    if @rating.save
      flash[:success] = t "ratings.success"
    else
      flash[:danger] = t "ratings.already"
    end
    redirect_to static_page_ratings_path
  end

  private

  def rating_params
    params.require(:rating).permit :soccer_field_id, :rating, :content
  end

  def find_soccer_field
    @soccer_field = SoccerField.find_by id: params[:rating][:soccer_field_id]
    return if @soccer_field

    flash[:warning] = t "comment_controller.fail"
    redirect_to static_page_path params[:soccer_field_id]
  end

  def load_soccer_field
    @soccer_field = SoccerField.find_by(id: params[:id])
    return if @soccer_field

    flash[:warning] = "message.update_booking.not_exist_id"
    redirect_to root_path
  end
end
