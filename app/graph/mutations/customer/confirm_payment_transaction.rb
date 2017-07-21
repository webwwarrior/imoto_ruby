module Mutations::Customer
  ConfirmPaymentTransaction = GraphQL::Relay::Mutation.define do
    name 'ConfirmPaymentTransaction'
    description 'Withdraw Mony From Credit Card for Order'

    input_field :order_id,         !types.ID
    input_field :trans_id,         !types.String
    input_field :save_credit_card, types.Boolean

    return_field :order, OrderType

    resolve Resolvers::Customer::ConfirmPaymentTransaction.new
  end
end
