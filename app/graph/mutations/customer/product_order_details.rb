module Mutations::Customer
  ProductOrderDetails = GraphQL::Relay::Mutation.define do
    name 'ProductOrderDetails'
    description 'Assign selected products to order'

    input_field :attributes,   types[AttributeInput]
    input_field :order_id,     !types.ID
    input_field :active_step,  types.String
    input_field :current_step, types.String

    return_field :order, OrderType

    resolve Resolvers::Customer::ProductOrderDetails.new
  end
end
