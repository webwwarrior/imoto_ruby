CouponType = GraphQL::ObjectType.define do
  name 'Coupon'
  description 'Coupon information'

  # Expose fields from the model
  field :id,                !types.ID
  field :name,              !types.String
  field :code,              !types.String
  field :minimum_purchase,  types.String
  field :discount_type,     types.String
  field :discount_amount,   types.String
  field :office_branch, types.String
  field :errors, types[types.String], "Reasons the object couldn't be created or updated" do
    resolve ->(obj, _args, _ctx) do
      return if obj.errors.full_messages.empty?
      raise GraphQL::ExecutionError.new(obj.errors.full_messages.join('; '))
    end
  end
end
