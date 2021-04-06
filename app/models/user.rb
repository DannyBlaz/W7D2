class User < ApplicationRecord
    validates :email, :session_token, uniqueness: true, presence: true
    validates :password_digest, presence: true
    validates :password, length: { minimum: 6, allow_nil: true }
    attr_reader :password

    after_initialize :ensure_session_token
    # before_validation :ensure_session_token


    # pseudo-code
#    steps to login
#    user submits username and password
#    check if that user exists with that username
#    check if the password matches
#    use password_digest
#    IF PASSWORD MATCHES
#    set their session token and sesssion's session token to be equal
#    session[:session_token] = user.session_token (this is not perfect one though!)

    def self.find_by_credentials(email, pw)
        user = User.find_by(email: email)
        return user if user && user.is_password?(pw)
        nil
    end

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end

    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64
    end

    def password=(pw)
        self.password_digest = BCrypt::Password.create(pw)
        @password = password
    end

    def is_password?(pw)
        password_obj = BCrypt::Password.new(self.password_digest)
        password_obj.is_password?(pw)
    end


end
