class User < ActiveRecord::Base
  has_secure_password
  has_many :hosted_events, class_name: "Event", foreign_key: "host_id"
  has_many :attendances
  has_many :events, through: :attendances
  has_many :comments
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :first_name, :last_name, :presence => true, length: { minimum:3 }
  validates :city, :presence => true
  validates :state, :presence => true, length: { is:2 }
  validates :email, :presence => true, :uniqueness => {:case_sensitive=>false}, :format => {:with=>VALID_EMAIL_REGEX} 
end
