HashType = GraphQL::InputObjectType.define do
  name 'Hash'

  argument :key,   types.String
  argument :value, types.String
end
