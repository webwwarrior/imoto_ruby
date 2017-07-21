ProductType = GraphQL::ObjectType.define do
  name 'Product'
  description 'Product information'

  field :id,              types.ID
  field :name,            !types.String
  field :description,     types.String
  field :sku,             types.String
  field :image,           types.String
  field :category,        CategoryType
  field :attribute_items, types[AttributeType] do
    resolve ->(product, _args, ctx) do
      if ctx[:current_user].company_id.present?
        customized_attributes = product.attribute_items.customized(ctx[:current_user].company_id)
        basic_attributes      = product.attribute_items.basic(ctx[:current_user].company_id)
        customized_attributes.to_a + basic_attributes.to_a
      else
        product.attribute_items
      end
    end
  end
  field :selected_order_attributes, types[OrderAttributeType]
end
