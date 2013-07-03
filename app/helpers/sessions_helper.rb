module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    # user.new_remember_token!
    # cookies.permanent[:remember_token] = remember_token
    # user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    if !cookies[:remember_token]
      false
      # remember_token = User.new_remember_token
      # cookies.permanent[:remember_token] = remember_token
    else
      !current_user.nil?
    end
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token  = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
    # remember_token = User.encrypted_token(cookies[:remember_token])
    # @current_user ||= User.find_by(remember_token: remember_token)
    # remember_token  = User.encrypt(cookies[:remember_token])
    # @current_user ||= User.find_by(remember_token: remember_token)
  end

end
