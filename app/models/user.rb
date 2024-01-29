class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :phone, presence: true
  validates :phone, length: { is: 10 }, numericality: true, uniqueness: true
  validate  :check_role, if: -> { role == true }

  with_options dependent: :destroy do |assoc|
    assoc.has_one :wallet, as: :accountable
    assoc.has_one :premium_wallet, class_name: 'Wallet', as: :accountable
    assoc.has_many :loans, foreign_key: 'admin_id'
    assoc.has_many :requested_loans, class_name: 'Loan', foreign_key: 'user_id'
  end

  before_create ->(user) { user.role ? build_wallet(balance: 1000000) : build_wallet(balance: 10000) }

  def admin?
    role == true
  end

  private

  def check_role
    if User.find_by(role: true)
      errors.add :role, 'only one admin can exist!'
    end
  end
end