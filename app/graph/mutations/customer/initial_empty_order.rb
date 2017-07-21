module Mutations::Customer
  InitialEmptyOrder = GraphQL::Relay::Mutation.define do
    name 'InitialEmptyOrder'
    description 'Create Initial Empty Order By Customer'

    return_field :order, OrderType

    resolve Resolvers::Customer::InitialEmptyOrder.new
  end
end
