class LoansController < ApplicationController
  before_action :set_loan, except: [:new, :create, :show]
  before_action :set_wallets, only: [:open, :repay_loan]

  def new
    @loan = Loan.new
  end

  def create
    @loan = current_user.requested_loans.build(loan_params)
    authorize! :create, @loan
    if @loan.save
      respond_to do |format|
        format.html { redirect_to '/' }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def approve
    if @loan.requested? and @loan.trigger_approve_loan
      @loan.admin = admin_user
    else
      flash[:alert] = "loan is not approved!"
    end
    redirect_to admin_root_path
  end

  def reject
    if @loan.requested? and @loan.trigger_reject_loan
      @loan.admin = admin_user
    else
      flash[:alert] = "loan is not rejected!"
    end
    redirect_to admin_root_path
  end

  def open
    if @loan.approved? and @loan.trigger_confirm_loan
      @loan.admin = admin_user
      @premium_wallet.update(balance: @premium_wallet.balance - @loan.amount)
      @wallet.update(balance: @wallet.balance + @loan.amount)
      @loan.interest_amount = (@loan.interest * @loan.amount)/100
      @loan.payable_amount = @loan.amount + @loan.interest_amount
      @loan.interest_updated_at = Time.now
      @loan.save
      redirect_to active_loans_path
    else
      flash[:alert] = "loan is not confirmed!"
      redirect_to confirmation_requests_path
    end
  end

  def reject_loan_user
    if @loan.approved?
      @loan.admin = admin_user
      @loan.save
      @loan.trigger_reject_loan_user
    else
      flash[:alert] = "loan is not rejected!"
    end
    redirect_to admin_root_path
  end

  def edit_interest; end

  def update_interest
    authorize! :update, @loan
    if @loan.update(interest: params[:loan][:interest])
      redirect_to admin_root_path
    else
      render :edit_interest, status: :unprocessable_entity
    end
  end

  def repay_loan
    if @wallet.balance >= @loan.payable_amount and @loan.open?
      @premium_wallet.update(balance: @premium_wallet.balance + @loan.payable_amount)
      @wallet.update(balance: @wallet.balance - @loan.payable_amount)
      @loan.trigger_repay_loan
      redirect_to admin_root_path
    else
      flash[:alert] = 'loan not repayed!'
      redirect_to active_loans_path
    end
  end

  private

    def loan_params
      params.require(:loan).permit(:amount, :reason, :name)
    end

    def set_loan
      @loan = Loan.find(params[:id])
    end

    def set_wallets
      @premium_wallet = admin_user.premium_wallet
      @wallet = current_user.wallet
    end
end