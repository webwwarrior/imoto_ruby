ProductInput = GraphQL::InputObjectType.define do
  name 'OrderProducts'
  description 'Product Information'

  argument :id,          !types.ID
  argument :quantity,    types.String
end
