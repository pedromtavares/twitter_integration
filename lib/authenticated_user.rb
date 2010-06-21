
require 'digest/sha1'

module AuthenticatedUser

  def self.included( base )
    base.extend( ClassMethods )
    base.send( :include, InstanceMethods )
    base.before_save :encrypt_password
    base.send( :attr_accessor, :password )

    base.validates_presence_of     :password,                   :if => :password_required?
    base.validates_presence_of     :password_confirmation,      :if => :password_required?
    base.validates_length_of       :password, :within => 4..40, :if => :password_required?
    base.validates_confirmation_of :password,                   :if => :password_required?
  end

  module ClassMethods

    # Authenticates a user by their email and unencrypted password.  Returns the user or nil.
    def authenticate(email, password)
      u = User.find_by_email email
      u && u.authenticated?(password) ? u : nil
    end

    # Encrypts some data with the salt.
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end

  end

  module InstanceMethods

    # before filter
    def encrypt_password
      return if self.password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s(:db)}--#{self.email}--") if self.new_record?
      self.password_hash = encrypt(self.password)
    end

    def password_required?
      self.password_hash.blank? || !self.password.blank?
    end

    # Encrypts the password with the user salt
    def encrypt(password)
      self.class.encrypt(password, self.salt)
    end

    def authenticated?(password)
      self.password_hash == encrypt(password)
    end

  end

end