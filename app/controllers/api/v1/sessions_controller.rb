module Api::V1
  class SessionsController < Devise::SessionsController
    acts_as_token_authentication_handler_for User, fallback: :none
    before_action :ensure_params_exist, only: [:create]
    before_action :load_user_authentication
    skip_before_action :verify_authenticity_token

    respond_to :json

    def create
      if @user.valid_password? user_params[:password]
        token = JsonWebToken.encode(user_id: @user.id, email: @user.email)
        time = Time.zone.now + 24.hours.to_i
        render json: {token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                      data: UserSerializer.new(@user).as_json}, status: :ok
      else
        render json: {message: "Invalid email/password combination"},
                     status: :unauthorized
      end
    end

    def destroy
      @user.destroy!
      render json: {
        success: true,
        data: UserSerializer.new(@user)
      }
    end

    private
    def user_params
      params.require(:session).permit :email, :password
    end

    def ensure_params_exist
      return if params[:session].present?

      render json: {message: "Missing params"}, status: :unprocessable_entity
    end

    def load_user_authentication
      @user = User.find_by email: user_params[:email]
      return login_invalid unless @user
    end

    def login_invalid
      render json:
        {message: "Invalid login"}, status: :ok
    end
  end
end
