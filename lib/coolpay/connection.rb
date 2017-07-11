module Coolpay
  class Connection
    attr_accessor :api_endpoint_url, :username, :api_key, :token

    def initialize(username:, api_key:, api_endpoint_url:nil)
      raise InvalidConnection, 'You must specify an API endpoint' if api_endpoint_url.nil?
      @api_endpoint_url = api_endpoint_url
      @username = username
      @api_key = api_key
      authenticate!
    end

    def create_recipient(name:)
      res = call_api '/recipients', method: :post, body: {recipient: {name: name}}
      if res.code == 201
        Recipient.new(name: res['recipient']['name'], id: res['recipient']['id'])
      end
    end

    def recipients(name: nil)
      if name
        res = call_api '/recipients', method: :get, query: {name: name}
      else
        res = call_api '/recipients', method: :get
      end

      if res.code == 200
        res['recipients'].map{ |r| Recipient.new(name: r['name'], id: r['id']) }
      end
    end

    def create_payment(amount:, recipient_id:, currency: 'GBP')
      res = call_api '/payments', method: :post, body: {
        payment: {amount: amount, recipient_id: recipient_id, currency: currency}
      }
      if res.code == 201
        Payment.new(
          amount: res['payment']['amount'],
          recipient: find_by_id(res['payment']['recipient_id'], recipients),
          id: res['payment']['id'],
          currency: res['payment']['currency'],
          status: res['payment']['status']
        )
      end
    end

    def payments
      res = call_api '/payments', method: :get
      if res.code == 200
        res['payments'].map{ |r| Payment.new(
          id: r['id'],
          amount: r['amount'],
          recipient: find_by_id(r['recipient_id'], recipients),
          status: r['status'],
          currency: r['currency']
        ) }
      end
    end

    private

    def find_by_id(id, list)
      list.select{|r| r.id == id}[0]
    end

    def url(path)
      "#{@api_endpoint_url}#{path}"
    end

    # Required parameters: method
    # Optional parameters: headers, body, query (all hashes)
    def call_api(path, params = {})
      raise ArgumentError, 'You must include an HTTP method' unless params[:method]
      raise InvalidConnection, 'You have not authenticated and have no token' unless @token
      headers = {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{@token}"
      }
      headers.merge!(params[:headers]) if params[:headers]

      arguments = {headers: headers}
      arguments.merge!({body: params[:body].to_json}) if params[:body]
      arguments.merge!({query: params[:query]}) if params[:query]

      HTTParty.send params[:method], url(path), arguments
    end

    def authenticate!
      headers = {'Content-Type' => 'application/json'}
      body = {username: @username, apikey: @api_key}
      res = HTTParty.post url('/login'), body: body.to_json, headers: headers
      if res.code == 200
        @token = JSON.parse(res.body)["token"]
      else
        raise InvalidConnection, 'Connection failed. Maybe your connection credentials are incorrect?'
      end
    end
  end
end
