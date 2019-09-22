require 'bcrypt'
class Student < ApplicationRecord
  has_secure_password
  #attr_accessor :email, :name, :password, :password_confirmation, :educational_level, :university, :maximum_books
  validates :email, :presence => true, :uniqueness => true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :educational_level,  :presence =>true
  validates :university,  :presence =>true
  #validates :password, :presence => {:message => "please enter password"}, :length => {minimum: 8}, allow_nil: true
  #validates :maximum_books, :presence => true, :length => {:in =>  1..1}
  
end