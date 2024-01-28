class InterestWorker
  include Sidekiq::Worker

  def perform(*args)
    open_loans = Loan.open
    open_loans.each do |loan|
      if Time.now >= loan.interest_updated_at.to_time + 5.minutes
        wallet = loan.user.wallet
        premium_wallet = loan.admin.premium_wallet
        if loan.payable_amount > wallet.balance
          BalanceTransferJob.perform_later(wallet, premium_wallet, loan)
        else
          loan.interest_count = loan.interest_count + 1
          loan.payable_amount = (loan.interest_amount * loan.interest_count) + loan.amount
          loan.interest_updated_at = Time.now
          loan.save
        end
      end
    end
  end
end