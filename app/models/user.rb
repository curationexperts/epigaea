class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles

  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ##
  # @see https://github.com/samvera/hyrax/pull/2340
  def name
    display_name || user_key
  end

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    display_name || user_key
  end

  def add_role(name)
    role = Role.find_by(name: name)
    role = Role.create(name: name) if role.nil?
    role.users << self
    role.save
    reload
  end

  def remove_role(name)
    role = Role.find_by(name: name)
    role.users.delete(self) if role && role.users && role.users.include?(self)
    reload
  end

  # Mailboxer (the notification system) needs the User object to respond to this method
  # in order to send emails
  def mailboxer_email(_object)
    email
  end

  # Hyrax 2.0 expects this to be set for the user
  def preferred_locale
    'en'
  end

  def ldap_before_save
    self.email = Devise::LDAP::Adapter.get_ldap_param(username, "mail").first
    self.display_name = Devise::LDAP::Adapter.get_ldap_param(username, "tuftsEduDisplayNameLF").first
  end
end

# Override a Hyrax class that expects to create system users with passwords
module Hyrax::User
  module ClassMethods
    def find_or_create_system_user(user_key)
      u = ::User.find_or_create_by(username: user_key)
      u.display_name = user_key
      u.email = "#{user_key}@example.com"
      u.password = ('a'..'z').to_a.shuffle(random: Random.new).join
      u.save
      u
    end
  end
end
