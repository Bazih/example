class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :perform_oauth

  def facebook
  end

  def twitter
  end

  private

  def perform_oauth
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user
      sign_in_and_redirect @user, event: :authentication
      kind = request.env['omniauth.auth'].provider.capitalize
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      session[:provider] = request.env['omniauth.auth'].provider
      session[:uid] = request.env['omniauth.auth'].uid
      redirect_to validate_sign_up_path
    end
  end
end
