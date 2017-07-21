AttributeType = GraphQL::ObjectType.define do
  name 'Attribute'
  description 'Attribute information'

  field :id,                  types.ID
  field :kind,                types.String
  field :data,                types.String do
    resolve ->(obj, _args, _ctx) { obj.formatted_data }
  end
  field :base_price,          !types.String
  field :base_quantity,       !types.String
  field :additional_price,    types.String
  field :company_id,          types.ID
  field :product,             ProductType
  field :parent_id,           types.ID
end
