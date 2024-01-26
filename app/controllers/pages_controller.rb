class PagesController < ApplicationController
  before_action :set_requested_loans, except: :check_wallet

  def index
    @loans = @requested_loans.requested
  end

  def confirmation_requests
    @loans = @requested_loans.approved
  end

  def active_loans
    @loans = @requested_loans.open
  end

  def rejected_loans
    @loans = @requested_loans.rejected
  end

  def closed_loans
    @loans = @requested_loans.closed
  end

  def check_wallet
    @balance = current_user.wallet.balance
  end

  private

  def set_requested_loans
    @requested_loans = current_user.requested_loans
  end
end
