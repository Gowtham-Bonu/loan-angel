class DashboardController < ApplicationController
  after_action :authorize_collection
  before_action :set_current_page

  def index
    @loans = Loan.requested
  end

  def active_loans
    @loans = Loan.open
  end

  def closed_loans
    @loans = Loan.closed
  end

  def check_premium_wallet
    @balance = current_user.premium_wallet.balance
  end

  private

  def authorize_collection
    authorize! :read, @loans
  end

  def set_current_page
    @current_page = params[:action]
    @current_controller = params[:controller]
  end
end
