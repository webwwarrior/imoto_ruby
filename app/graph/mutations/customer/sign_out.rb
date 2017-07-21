module Mutations::Customer
  SignOut = GraphQL::Relay::Mutation.define do
    name 'SignOutCustomer'
    description 'Sign Out Customer'

    return_field :id, !types.ID

    resolve Resolvers::Customer::SignOut.new
  end
end
