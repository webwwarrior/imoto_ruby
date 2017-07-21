OrderType = GraphQL::ObjectType.define do
  name 'Order'
  description 'Order information'

  field :id,                  types.ID
  field :status,              types.String
  field :address,             types.String
  field :second_address,      types.String
  field :city,                types.String
  field :state,               types.String
  field :zip_code,            types.String
  field :listing_price,       types.String
  field :square_footage,      types.String
  field :number_of_beds,      types.String
  field :number_of_baths,     types.String
  field :listing_description, types.String
  field :additional_notes,    types.String
  field :coupon,              CouponType
  field :step,                types.String
  field :current_step,        types.String
  field :active_step,         types.String
  field :special_request,     types.String
  field :photographer,        PhotographerType
  field :customer,            CustomerType
  field :order_attributes,    types[OrderAttributeType]
  field :products,            types[ProductType]

  field :errors, types[types.String], "Reasons the object couldn't be created or updated" do
    resolve ->(obj, _args, _ctx) do
      return if obj.errors.full_messages.empty?
      raise GraphQL::ExecutionError.new(obj.errors.full_messages.join('; '))
    end
  end
end
