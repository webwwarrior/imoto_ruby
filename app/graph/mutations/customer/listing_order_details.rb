module Mutations::Customer
  ListingOrderDetails = GraphQL::Relay::Mutation.define do
    name 'ListingOrderDetails'
    description 'Update Listing Order Details By Customer'

    input_field :id,                  !types.ID
    input_field :address,             !types.String
    input_field :second_address,      types.String
    input_field :city,                !types.String
    input_field :state,               !types.String
    input_field :zip_code,            !types.String
    input_field :listing_price,       !types.String
    input_field :square_footage,      !types.String
    input_field :number_of_beds,      !types.String
    input_field :number_of_baths,     !types.String
    input_field :listing_description, types.String
    input_field :additional_notes,    types.String
    input_field :active_step,         types.String
    input_field :current_step,        types.String

    return_field :order, OrderType

    resolve Resolvers::Customer::ListingOrderDetails.new
  end
end
