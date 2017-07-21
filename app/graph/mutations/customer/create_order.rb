module Mutations::Customer
  CreateOrder = GraphQL::Relay::Mutation.define do
    name 'CreateOrder'
    description 'Create Order By Customer'

    input_field :address,             !types.String
    input_field :second_address,      types.String
    input_field :city,                !types.String
    input_field :state,               !types.String
    input_field :zip_code,            !types.String
    input_field :listing_price,       types.String
    input_field :square_footage,      types.String
    input_field :number_of_beds,      types.String
    input_field :number_of_baths,     types.String
    input_field :listing_description, types.String
    input_field :additional_notes,    types.String
    input_field :coupon_value,        types.String
    input_field :photographer_id,     !types.ID
    input_field :products,            !types[ProductInput]

    return_field :order, OrderType

    resolve Resolvers::Customer::CreateOrder.new
  end
end
