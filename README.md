# Coolpay Wrapper Gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dannysmith_coolpay'
```

And then execute:

    $ bundle

Or install it yourself with:

    $ gem install dannysmith_coolpay

## Usage

```ruby
c = Connection.new username: 'username',
                   api_key: 'ABC123',
                   api_endpoint_url: 'https://coolpay.herokuapp.com/api'

c.create_recipient name: 'Joe Bloggs' #=> <Recipient>
c.recipients #=> List of all recipients

# Making a payment
lucky_winner = c.recipients(name: 'Joe Bloggs').first

c.create_payment amount: '1000.00',
                 currency: 'GBP',
                 recipient_id: lucky_winner.id

c.payments #=> List of all payments
```

## To run the tests

Set three environment variables:

```
COOLPAY_USERNAME=mrbloggs
COOLPAY_API_KEY=ABC12345678
COOLPAY_API_ENDPOINT_URL=https://coolpay.herokuapp.com/api
```

Then run `rake spec`. On the first run, [VCR](https://github.com/vcr/vcr) will record most of the API calls and use the stored requests/responses for subsequent test runs. There is one test that will always hit the live API, though.

## Stuff this should have in it if it wasn't an exercise

* [ ] More sensible tests for `Connection#payments` and `Connection#recipients`.
* [ ] A way of reauthorizing, in case the token times out.
* [ ] A bunch of refactoring for brevity.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
