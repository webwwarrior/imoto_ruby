module Mutations::Customer
  PhotographerOrderDetails = GraphQL::Relay::Mutation.define do
    name 'PhotographerOrderDetails'
    description 'Assign Photographer To Order'

    input_field :order_id,        !types.ID
    input_field :photographer_id, !types.ID
    input_field :time_range,      !types.String, 'Should be in format
                                                 "2016-10-21T10:25:00+00:00..2016-10-21T14:00:00+00:00"'
    input_field :special_request, types.String
    input_field :active_step,     types.String
    input_field :current_step,    types.String

    return_field :order, OrderType

    resolve Resolvers::Customer::PhotographerOrderDetails.new
  end
end
