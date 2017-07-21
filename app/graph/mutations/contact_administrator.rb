module Mutations
  ContactAdministrator = GraphQL::Relay::Mutation.define do
    name 'ContactAdministrator'
    description 'Contact Administrator'

    input_field :sender_email, !types.String
    input_field :subject,      !types.String
    input_field :body,         !types.String

    return_field :sender_email, !types.String
    return_field :body,         !types.String

    resolve Resolvers::ContactAdministrator.new
  end
end
