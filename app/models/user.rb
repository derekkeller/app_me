class User < ActiveRecord::Base
  attr_accessor :password

  validates :name, :presence => true
  validates :email, :presence => true
  validates :password, :presence => true

  def has_password?(submitted_password)
    encrypted_password == secure_password(submitted_password)
  end


  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    if user && user.has_password(submitted_password)
      user
    else
      nil
    end
  end


  private
  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)    
    secure_hash("#{salt}--#{submitted_password}")
  end

  def make_salt
    secure_hash("#{submitted_pasword}--#{Time.now.utc}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

end


