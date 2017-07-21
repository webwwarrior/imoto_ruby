class AuthorizeNet
  class TransactionError < StandardError; end

  include HTTParty
  base_uri Rails.application.secrets['authorize_net_url']

  def initialize(customer)
    @customer = customer

    @auth = {
      username: Rails.application.secrets['authorize_net_username'],
      password: Rails.application.secrets['authorize_net_password']
    }
  end

  def merchant_authentication
    { name:           Rails.application.secrets['authorize_net_api_login_id'],
      transactionKey: Rails.application.secrets['authorize_net_transaction_key'] }
  end

  # rubocop:disable all
  def capture_authorized_amount(transaction_id:, amount:, save_credit_card:)
    body = {
      createTransactionRequest: {
        merchantAuthentication: merchant_authentication,
        transactionRequest: {
          transactionType: 'priorAuthCaptureTransaction',
          amount: amount,
          refTransId: transaction_id
        }
      }
    }.to_json

    response = self.class.post('', basic_auth: @auth, body: body, headers: { 'Content-Type' => 'application/json' })
    result = JSON.parse(response.body.delete('﻿')) #Caution!!! Delete from response encoded symbol

    if result['messages']['resultCode'].eql?('Error')
      raise AuthorizeNet::TransactionError.new(result['messages']['message'].to_sentence)
    end

    if save_credit_card && result['transactionResponse']['authCode'].present?
      update_cutomer_information(result['transactionResponse'])
    end

    true
  end
  # rubocop:enable all

  def update_cutomer_information(result)
    credit_card = @customer.credit_cards.find_or_initialize_by(trans_id: result['transId'])

    return if credit_card.persisted?
    credit_card.update(
      auth_code:      result['authCode'],
      account_number: result['accountNumber'],
      account_type:   result['accountType']
    )
  end

  # rubocop:disable all
  # created for development purposes only (debugging).

  def authorize_credit_card
    main_body = {
      createTransactionRequest: {
        merchantAuthentication: merchant_authentication,
        transactionRequest: {
          transactionType: 'authOnlyTransaction',
          amount: '8.75',
          payment: {
            creditCard: {
              cardNumber: '5424000000000015',
              expirationDate: '1220',
              cardCode: '900'
            }
          }
        }
      }
    }

    response = self.class.post('', basic_auth: @auth, body: main_body.to_json,
                                   headers: { 'Content-Type' => 'application/json' })
    JSON.parse(response.body.delete('﻿'))
  end
  # rubocop:enable all
end
