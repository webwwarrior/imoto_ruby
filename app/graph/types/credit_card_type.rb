CreditCardType = GraphQL::ObjectType.define do
  name 'CreditCard'
  description 'Credit Card Information'

  # Expose fields from the model
  field :id,               types.ID
  field :account_number,   types.String
  field :account_type,     types.String
  field :trans_id,         types.String
  field :save_credit_card, types.Boolean

  field :errors, types[types.String], "Reasons the object couldn't be created or updated" do
    resolve ->(obj, _args, _ctx) do
      return if obj.errors.full_messages.empty?
      raise GraphQL::ExecutionError.new(obj.errors.full_messages.join('; '))
    end
  end
end
