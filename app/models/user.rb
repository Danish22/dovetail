class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  include Gravtastic
  gravtastic

  before_create :set_trial_ending

  has_many :created_spaces, class: Space
  has_many :created_members, class: Member

  has_many :user_spaces
  has_many :spaces, through: :user_spaces

  has_many :payment_methods

  has_many :invitations, :class_name => "Invite", :foreign_key => 'recipient_id'
  has_many :sent_invites, :class_name => "Invite", :foreign_key => 'sender_id'

  has_many :meetingrooms

  after_create :add_to_space_if_invited

  # Virtual Attribute
  attr_accessor :invite_token

  def trialing?
    true #Date.today.to_time(:utc) < self.trial_ending 
  end

  # Mostly for the ActiveAdmin interface
  def to_s
    self.email
  end

  def set_trial_ending
    self.trial_ending = Date.today.to_time(:utc) + 30.days
  end

  def add_to_space_if_invited
    unless invite_token.blank?
      invite = Invite.find_by_token(invite_token)
      if invite
        invite.space.users << self
        invite.recipient_id = self.id
        invite.save!
      end
    end
  end

  def default_space
    spaces.first
  end

end
