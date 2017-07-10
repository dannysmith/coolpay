module Coolpay
  class Payment
    attr_reader :id, :amount, :currency, :recipient_id, :status
    def initialize(id:,amount:,currency:,recipient_id:,status:)
      @id = id
      @amount = amount
      @currency = currency
      @recipient_id = recipient_id
      @status = status
    end
  end
end
