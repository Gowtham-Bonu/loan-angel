class Wallet < ApplicationRecord
  belongs_to :accountable, polymorphic: true

  validates :balance, presence: true
  validates :balance, numericality: { only_integer: true }
end
