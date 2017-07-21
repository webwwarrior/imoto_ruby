module Mutations::Customer
  ResetPassword = GraphQL::Relay::Mutation.define do
    name 'ResetPassword'
    description 'Reset Password'

    input_field :reset_password_token,  !types.String
    input_field :password,              !types.String
    input_field :password_confirmation, !types.String

    return_field :customer, CustomerType

    resolve Resolvers::Customer::ResetPassword.new
  end
end
