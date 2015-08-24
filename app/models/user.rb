class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  AVATAR_SIZES = {
      micro: 16,
      thumb: 32,
      middle: 128,
      large: 512
  }

  def gravatar_url(size)
    size = avatar_size(size)
  end

  def avatar_size(size)
    AVATAR_SIZES(size)
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = (auth['info'].present? and auth.info[:email].present?) ? auth.info[:email] : nil
    user = User.find_by(email: email)
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      if email
        user = User.new(
            email: email,
            password: password,
            password_confirmation: password
        )
        user.skip_confirmation!
        user.save!

        user.create_authorization(auth)
      end
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def owns?(object)
    id == object.user_id
  end

  def subscribed_to?(question)
    Subscription.exists?(user: self, question: question)
  end
end