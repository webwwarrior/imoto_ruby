CompanyType = GraphQL::ObjectType.define do
  name 'Company'
  description 'Company information'

  # Expose fields from the model
  field :id,         types.ID
  field :name,       !types.String
  field :logo,       types.String
  field :website,    types.String
  field :city,       types.String
  field :state,      types.String
  field :zip_code,   types.String
  field :office_branch, types.String
  field :errors, types[types.String], "Reasons the object couldn't be created or updated" do
    resolve ->(obj, _args, _ctx) do
      return if obj.errors.full_messages.empty?
      raise GraphQL::ExecutionError.new(obj.errors.full_messages.join('; '))
    end
  end
end
