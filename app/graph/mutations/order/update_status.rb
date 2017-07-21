module Mutations::Order
  UpdateStatus = GraphQL::Relay::Mutation.define do
    name 'UpdateStatus'
    description 'Update Order Status'
    input_field :order_id,    !types.ID
    input_field :status,      !types.String

    return_field :status,     types.String

    resolve Resolvers::Order::UpdateStatus.new
  end
end
