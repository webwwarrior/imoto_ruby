CategoryType = GraphQL::ObjectType.define do
  name 'Category'
  description 'Category information'

  # Expose fields from the model
  field :id,          !types.ID
  field :name,        !types.String
end
