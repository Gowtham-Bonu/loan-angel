class Loan < ApplicationRecord
  include AASM

  validates :amount, :reason, :name, presence: true
  validates :amount, numericality: { in: 100..9000 }
  validates :reason, length: { in: 10..15 }
  validates :interest, numericality: { in: 5..10 }

  with_options optional: true do |assoc|
    assoc.belongs_to :user, optional: true
    assoc.belongs_to :admin, class_name: 'User', optional: true
  end

  default_scope { order(id: :desc) }

  aasm column: 'status' do
    state :requested, initial: true
    state :approved, :open, :closed, :rejected

    event :approve_loan do
      transitions from: :requested, to: :approved
    end

    event :reject_loan do
      transitions from: :requested, to: :rejected
    end

    event :reject_loan_user do
      transitions from: :approved, to: :rejected
    end

    event :confirm_loan do
      transitions from: :approved, to: :open
    end

    event :repay_loan do
      transitions from: :open, to: :closed
    end
  end

  def trigger_approve_loan
    self.aasm.fire!(:approve_loan)
  end

  def trigger_reject_loan
    self.aasm.fire!(:reject_loan)
  end

  def trigger_confirm_loan
    self.aasm.fire!(:confirm_loan)
  end

  def trigger_repay_loan
    self.aasm.fire!(:repay_loan)
  end

  def trigger_reject_loan_user
    self.aasm.fire!(:reject_loan_user)
  end
end
