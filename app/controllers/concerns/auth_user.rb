module AuthUser
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, except: [:index, :show]
  end

end