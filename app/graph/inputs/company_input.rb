CompanyInput = GraphQL::InputObjectType.define do
  name 'CompanyInput'
  description 'Company Information'

  # Expose fields from the model
  argument :id,         types.ID
  argument :name,       types.String
  argument :logo,       types.String
  argument :website,    types.String
  argument :city,       types.String
  argument :state,      types.String
  argument :zip_code,   types.String
  argument :office_branch, types.String
end
