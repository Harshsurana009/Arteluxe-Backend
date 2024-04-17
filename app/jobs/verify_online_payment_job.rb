
class VerifyOnlinePaymentJob < ApplicationJob
  queue_as :default

  def perform(payment)
    Website::Api::VerifyOnlinePayment.call(payment)
  end
end
