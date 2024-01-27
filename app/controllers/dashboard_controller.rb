class DashboardController < ApplicationController
  before_action :set_current_page, except: :check_premium_wallet

  def index
    @loans = Loan.requested
    authorize! :read, @loans
  end

  def active_loans
    @loans = Loan.open
    authorize! :read, @loans
  end

  def closed_loans
    @loans = Loan.closed
    authorize! :read, @loans
  end

  def check_premium_wallet
    @balance = current_user.premium_wallet.balance
  end

  private

  def set_current_page
    @current_page = params[:action]
    @current_controller = params[:controller]
  end
end
