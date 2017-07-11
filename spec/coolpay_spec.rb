require 'spec_helper'
describe Coolpay do
  let(:valid_username) { ENV['COOLPAY_USERNAME'] }
  let(:valid_api_key) { ENV['COOLPAY_API_KEY'] }
  let(:valid_endpoint_url) { ENV['COOLPAY_API_ENDPOINT_URL'] }
  let(:connection) { Coolpay::Connection.new username: valid_username, api_key: valid_api_key, api_endpoint_url: valid_endpoint_url }

  it 'has a version number' do
    expect(Coolpay::VERSION).not_to be nil
  end

  describe Coolpay::Recipient do
    let(:recipient) { Coolpay::Recipient.new name: 'Jake McFriend', id: '6e7b4cea-5957-11e6-8b77-86f30ca893d3'}

    it 'should instansiate correctly' do
      expect(recipient).to be_a Coolpay::Recipient
      expect(recipient.name).to eq 'Jake McFriend'
      expect(recipient.id).to eq '6e7b4cea-5957-11e6-8b77-86f30ca893d3'
    end
  end

  describe Coolpay::Payment do
    let(:recipient) { Coolpay::Recipient.new name: 'Jake McFriend', id: '6e7b4cea-5957-11e6-8b77-86f30ca893d3'}
    let(:payment) { Coolpay::Payment.new id: '31db334f-9ac0-42cb-804b-09b2f899d4d2',
                                         amount: '10.5',
                                         currency: 'GBP',
                                         recipient: recipient,
                                         status: 'processing'
                                         }
    it 'should instansiate correctly' do
      expect(payment).to be_a Coolpay::Payment
      expect(payment.id).to eq '31db334f-9ac0-42cb-804b-09b2f899d4d2'
      expect(payment.amount).to eq '10.5'
      expect(payment.currency).to eq 'GBP'
      expect(payment.recipient.id).to eq '6e7b4cea-5957-11e6-8b77-86f30ca893d3'
      expect(payment.status).to eq 'processing'
    end
  end

  describe Coolpay::Connection, :vcr do
    it 'raises an exception if endpoint is nil' do
      expect { Coolpay::Connection.new(username: valid_username,
                            api_key: valid_api_key,
                            api_endpoint_url: nil)}.to raise_error InvalidConnection
    end

    it 'instansiates with correct details' do
      expect {connection}.not_to raise_error
      expect(connection.username).to eq valid_username
      expect(connection.api_key).to eq valid_api_key
      expect(connection.api_endpoint_url).to eq valid_endpoint_url
    end

    it 'connects to the API and retrives a token' do
      expect(connection.token).not_to be_nil
    end

    context 'recipients' do
      it 'creates a recipient' do
        r = connection.create_recipient(name: 'Joe Bloggs')
        expect(r).to be_a Coolpay::Recipient
        expect(r.name).to eq 'Joe Bloggs'
        expect(r.id).not_to be_nil
      end

      it 'lists all recipients' do
        r1 = connection.create_recipient(name: 'Number One')
        r2 = connection.create_recipient(name: 'Number Two')
        recipients = connection.recipients
        expect(recipients).to be_a Array
      end

      it 'Returns an empty array when no users are found' do
        expect(connection.recipients(name: 'A user that definitely is not in the list')).to eq []
      end
    end

    context 'payments' do
      it 'creates a payment' do
        recipient = connection.recipients.first
        payment = connection.create_payment amount: '10.5', currency: 'USD', recipient_id: recipient.id
        expect(payment).to be_a Coolpay::Payment
        expect(payment.amount).to eq '10.5'
        expect(payment.currency).to eq 'USD'
        expect(payment.recipient.id).to eq recipient.id
        expect(payment.id).not_to be_nil
      end

      it 'Lists all payments' do
        recipient = connection.recipients.first
        payment1 = connection.create_payment amount: '100.0', currency: 'GBP', recipient_id: recipient.id
        payment2 = connection.create_payment amount: '1000.0', currency: 'BTC', recipient_id: recipient.id

        payments = connection.payments
        expect(payments).to be_a Array
      end
    end
  end

  context 'without VCR' do
    describe Coolpay::Connection do
      it 'searches for a recipient by name' do
        VCR.turn_off!
        random_name = SecureRandom.uuid
        r = connection.create_recipient(name: random_name)
        expect(connection.recipients(name: random_name).size).to eq 1
        VCR.turn_on!
      end
    end
  end
end
