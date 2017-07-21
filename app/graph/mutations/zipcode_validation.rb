module Mutations
  ZipcodeValidation = GraphQL::Relay::Mutation.define do
    name 'ZipcodeValidation'
    description 'Zip code Validation'

    input_field :value,      !types.String
    input_field :state_name, !types.String

    return_field :status,    !types.String

    resolve Resolvers::ZipcodeValidation.new
  end
end
