class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  before_save :downcase_email
  ransack_alias :user, :name_or_email_or_phone
  validates :email, format: {with: Settings.email_regex},
                    uniqueness: {case_sensitive: false},
                    length: {maximum: Settings.model.user.email_max},
                    presence: true
  validates :password,  length: {minimum: Settings.model.user.password_min},
                        presence: true
  validates :name, length:
                  {maximum: Settings.model.profile.name_length_max_50},
                  allow_blank: true
  validates :address, length:
                  {maximum: Settings.model.profile.length_max_255},
                  allow_blank: true
  validates :country, length:
                  {maximum: Settings.model.profile.length_max_255},
                  allow_blank: true
  validates :phone, presence: true, format: {with: Settings.phone_regex},
                    allow_blank: true
  enum role: {user: 0, admin: 1}

  scope :order_by_name, ->{order :name}

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.link_expired.hours_2.hours.ago
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def self.from_omniauth auth
    result = User.find_by email: auth.info.email
    return result if result

    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.uid = auth.uid
    end
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
