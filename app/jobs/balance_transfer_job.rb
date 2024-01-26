class BalanceTransferJob < ApplicationJob
  queue_as :default

  def perform(wallet, premium_wallet, loan)
    premium_wallet.update(balance: premium_wallet.balance + wallet.balance)
    wallet.update(balance: 0)
    loan.trigger_repay_loan
  end
end
