class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :admin
  before_save :encrypt_password

  has_many :microposts,    :dependent => :destroy
  has_many :relationships, :dependent => :destroy,
                           :foreign_key => "follower_id"
  has_many :reverse_relationships, :dependent => :destroy,
                           :foreign_key => "followed_id",
                           :class_name => "Relationship"
  has_many :followers, :through => :reverse_relationships, :source => :follower
  has_many :following, :through => :relationships, :source => :followed
  
  validates :name, :presence => true
  validates :email, :presence => true
  validates :password, :presence => true, :on => :create

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    (user && user.has_password?(submitted_password) ) ? user : nil
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end


  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)    
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end
# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  email              :string(255)
#  name               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

