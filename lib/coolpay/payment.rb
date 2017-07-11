module Coolpay
  class Payment
    attr_reader :id, :amount, :currency, :recipient, :status
    def initialize(id:,amount:,currency:,recipient:,status:)
      @id = id
      @amount = amount
      @currency = currency
      @recipient = recipient
      @status = status
    end
  end
end
