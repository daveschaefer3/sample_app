class User < ActiveRecord::Base
  before_save { email.downcase! }
  before_create :create_remember_token
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  # def User.new_remember_token
  #   SecureRandom.urlsafe_base64
  # end

  def new_remember_token!
    create_remember_token
    save!(validate: false)
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token)
    
    # cost = if ActiveModel::SecurePassword.min_cost
    #          BCrypt::Engine::MIN_COST
    #        else
    #          BCrypt::Engine::DEFAULT_COST
    #        end
    # BCrypt::Password.create(token, cost: cost)
  end

  # def User.encrypted_token(token)
  #   Digest::SHA1.hexdigest(token)
  # end

  private

    def create_remember_token
      # self.remember_token = User.encrypted_token(SecureRandom.urlsafe_base64)
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end