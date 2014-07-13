class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :created_spaces, class: Space
  has_many :created_mmebers, class: Member

  has_many :user_spaces
  has_many :spaces, through: :user_spaces

  has_many :payment_methods

  def full_name
    [self.first_name, self.last_name].compact.reject{|f| f.blank? }.join(' ')
  end

  def to_s
    self.email
  end
end
