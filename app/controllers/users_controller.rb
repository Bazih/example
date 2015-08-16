class UsersController < ApplicationController
  skip_authorization_check

  def validate_sign_up
    @user = User.new

    if request.post?
      @user = User.create(email: user_params[:email],
                          password: user_params[:password],
                          password_confirmation: user_params[:password_confirmation])
      if @user.persisted?
        @user.authorizations.create(provider: session[:provider], uid: session[:uid])
        @user.send_confirmation_instructions
        redirect_to new_user_confirmation_path
      else
        @show_errors = true
      end
    end
  end

  private

  def user_params
    params.require(:user).permit([:email, :password, :password_confirmation, :provider, :uid])
  end
end