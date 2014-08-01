class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  before_create :set_trial_ending

  has_many :created_spaces, class: Space
  has_many :created_members, class: Member

  has_many :user_spaces
  has_many :spaces, through: :user_spaces

  has_many :payment_methods

  def trialing?
    Date.today.to_time(:utc) < self.trial_ending 
  end

  def full_name
    [self.first_name, self.last_name].compact.reject{|f| f.blank? }.join(' ')
  end

  # Mostly for the ActiveAdmin interface
  def to_s
    self.email
  end

  def set_trial_ending
    self.trial_ending = Date.today.to_time(:utc) + 14.days
  end
end
