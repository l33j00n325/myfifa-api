# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  full_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  PERMITTED_ATTRIBUTES = %i[
    email
    full_name
    username
  ].freeze

  def self.permitted_attributes
    PERMITTED_ATTRIBUTES
  end

  has_many :teams, dependent: :destroy

  validates :username,
            length: { minimum: 6 },
            uniqueness: { case_sensitive: false }

  before_create :set_default_bools

  def set_default_bools
    self.admin ||= false
  end

  def send_reset_password_instructions
    token = set_reset_password_token
    UsersMailer.reset_password_instructions(self, token).deliver_now
  end
end
