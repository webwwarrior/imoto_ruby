UserType = GraphQL::ObjectType.define do
  name 'User'
  description 'An user entry, returns basic user information'

  field :id,               types.ID,      'This id of this user'
  field :email,            !types.String, 'The email of this user'
  field :avatar,           types.String

  field :role, types.String do
    resolve ->(obj, _args, _ctx) { obj.class.to_s }
  end

  field :errors, types[types.String], "Reasons the object couldn't be created or updated" do
    resolve ->(obj, _args, _ctx) do
      return if obj.errors.full_messages.empty?
      raise GraphQL::ExecutionError.new(obj.errors.full_messages.join('; '))
    end
  end
end
