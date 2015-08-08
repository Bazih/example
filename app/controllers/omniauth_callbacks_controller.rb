class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(request.env['omniauth.auth'])
        if @user
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          #session["devise.twitter_data"] = request.env["omniauth.auth"]
          redirect_to validate_sign_up_path(:provider => request.env['omniauth.auth'].provider, :uid => request.env['omniauth.auth'].uid.to_s)
        end
       end
    }
  end

  [:twitter, :facebook].each do |provider|
    provides_callback_for provider
  end

end