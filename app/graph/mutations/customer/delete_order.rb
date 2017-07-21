module Mutations::Customer
  DeleteOrder = GraphQL::Relay::Mutation.define do
    name 'DeleteOrder'
    description 'Delete Order By Customer'

    input_field :id, !types.ID

    return_field :status, types.String

    resolve Resolvers::Customer::DeleteOrder.new
  end
end
