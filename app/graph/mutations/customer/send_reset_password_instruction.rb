module Mutations::Customer
  SendResetPasswordInstruction = GraphQL::Relay::Mutation.define do
    name 'SendResetPasswordInstruction'
    description 'Send Reset Password Instruction'

    input_field :email, !types.String

    return_field :customer, CustomerType

    resolve Resolvers::Customer::SendResetPasswordInstruction.new
  end
end
