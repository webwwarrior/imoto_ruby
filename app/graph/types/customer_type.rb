CustomerType = GraphQL::ObjectType.define do
  name 'Customer'
  description 'An user entry, returns basic user information'

  # Expose fields from the model
  field :id,           types.ID,      'This id of this user'
  field :email,        !types.String, 'The email of this user'
  field :second_email, types.String
  field :third_email,  types.String
  field :full_name,    types.String
  field :mobile,       types.String
  field :website,      types.String
  field :status,       types.String
  field :avatar,       types.String
  field :role,         types.String
  field :company,      CompanyType
  field :errors, types[types.String], "Reasons the object couldn't be created or updated" do
    resolve ->(obj, _args, _ctx) do
      return if obj.errors.full_messages.empty?
      raise GraphQL::ExecutionError.new(obj.errors.full_messages.join('; '))
    end
  end
end
