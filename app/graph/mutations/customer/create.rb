module Mutations::Customer
  Create = GraphQL::Relay::Mutation.define do
    name 'CreateCustomer'
    description 'Create Customer(Homeowner/Agent) and corresponding company'

    input_field :role,                  !types.String
    input_field :full_name,             !types.String
    input_field :email,                 !types.String
    input_field :password,              !types.String
    input_field :password_confirmation, !types.String
    input_field :mobile,                types.String
    input_field :website,               types.String
    input_field :avatar,                types.String, 'This field should have the following representation ' \
                                                      '"#!file:some_name", where "some_name" could be for example, ' \
                                                      'avatar1, avatar2  etc.' \
                                                      'Then you have to attach photos like here: ' \
                                                      'http://storage4.static.itmages.com/i/16/1201/h_1480588768_9499993_4e4333a368.png'
    input_field :second_email,          types.String
    input_field :third_email,           types.String
    input_field :company_id,            types.ID

    return_field :customer, CustomerType

    resolve Resolvers::Customer::Create.new
  end
end
