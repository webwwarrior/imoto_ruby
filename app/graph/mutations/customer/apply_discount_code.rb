module Mutations::Customer
  ApplyDiscountCode = GraphQL::Relay::Mutation.define do
    name 'ApplyDiscountCode'
    description 'Apply Discount Code To Order'

    input_field :code,     !types.String
    input_field :order_id, !types.ID

    return_field :order, OrderType

    resolve Resolvers::Customer::ApplyDiscountCode.new
  end
end
