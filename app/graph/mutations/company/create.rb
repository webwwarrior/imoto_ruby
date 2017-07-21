module Mutations::Company
  Create = GraphQL::Relay::Mutation.define do
    name 'CreateCompany'
    description 'Add a new company from Agent form'

    input_field :name,            !types.String
    input_field :office_branch,   !types.String
    input_field :website,         types.String
    input_field :logo,            types.String
    input_field :city,            types.String
    input_field :zip_code,        types.String
    input_field :state,           types.String

    return_field :company, CompanyType

    resolve Resolvers::Company::Create.new
  end
end
