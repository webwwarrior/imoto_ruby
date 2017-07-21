module Mutations::Photographer
  Update = GraphQL::Relay::Mutation.define do
    name 'UpdatePhotographer'
    description 'Update Photographer'
    input_field :first_name,            types.String
    input_field :last_name,             types.String
    input_field :email,                 types.String
    input_field :password,              types.String
    input_field :password_confirmation, types.String
    input_field :phone,                 types.String
    input_field :avatar,                types.String, 'This field should have the following representation ' \
                                                      '"#!file:some_name", where "some_name" could be for example, ' \
                                                      'avatar1, avatar2  etc.' \
                                                      'Then you have to attach photos like here: ' \
                                                      'http://storage4.static.itmages.com/i/16/1201/h_1480588768_9499993_4e4333a368.png'

    return_field :photographer, PhotographerType

    resolve Resolvers::Photographer::Update.new
  end
end
