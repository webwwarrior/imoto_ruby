OrderAttributeType = GraphQL::ObjectType.define do
  name 'OrderAttribute'
  description 'Order Attributes Information'

  field :id,                       types.ID
  field :order_id,                 types.ID
  field :attribute_item_id,        types.ID
  field :quantity,                 types.String
  field :price,                    types.String
  field :name,                     types.String
  field :document,                 types.String
  field :photos,                   types.String
  field :photographer_attachments, types[PhotographerAttachmentType]
  field :data,                     types.String do
    resolve ->(obj, _args, _ctx) { obj.formatted_data }
  end
  field :kind,                     types.String do
    resolve ->(obj, _args, _ctx) { obj&.attribute_item&.kind }
  end

  field :errors, types[types.String], "Reasons the object couldn't be created or updated" do
    resolve ->(obj, _args, _ctx) do
      return if obj.errors.full_messages.empty?
      raise GraphQL::ExecutionError.new(obj.errors.full_messages.join('; '))
    end
  end
end
