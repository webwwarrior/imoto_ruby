module Mutations::User
  SignIn = GraphQL::Relay::Mutation.define do
    name 'SignInUser'
    description 'Sign In User'

    input_field :email,    !types.String
    input_field :password, !types.String
    input_field :remember_me, types.Boolean

    return_field :user, UserType

    resolve Resolvers::User::SignIn.new
  end
end
