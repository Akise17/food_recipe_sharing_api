class AuthenticateUser
  prepend SimpleCommand
  
  def initialize(email)
    @email = email
  end
  
  def call
    payload = {
      user_id: api_user.id,
      role: api_user.role
    }
    JsonWebToken.encode(payload) if api_user
  end
  
  private
  
  attr_accessor :email
  
  def api_user
    user = User.find_by_email(email)
    
    unless user.present?
      errors.add :message, "Invalid email"
      return nil
    end
    
    return user
  end
    
end