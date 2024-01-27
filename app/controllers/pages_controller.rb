class PagesController < ApplicationController
  before_action :set_state, except: :check_wallet

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

  def set_state
    @requested_loans = current_user.requested_loans
    @current_page = params[:action]
    @current_controller = params[:controller]
  end
end
