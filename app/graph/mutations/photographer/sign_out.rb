module Mutations::Photographer
  SignOut = GraphQL::Relay::Mutation.define do
    name 'SignOutPhotographer'
    description 'Sign Out Photographer'

    return_field :id, !types.ID

    resolve Resolvers::Photographer::SignOut.new
  end
end
