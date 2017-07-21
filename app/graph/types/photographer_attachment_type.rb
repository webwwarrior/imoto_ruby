PhotographerAttachmentType = GraphQL::ObjectType.define do
  name 'PhotographerAttachment'
  description 'File attached by photographer to order attribute'

  field :id,                      types.ID
  field :photographer_id,         types.ID
  field :order_attribute_id,      types.ID
  field :attachment,              !types.String
  field :attachment_content_type, types.String

  # eWarp attributes
  field :bucket,                  types.String
  field :key,                     types.String
  field :name,                    types.String
  field :md5,                     types.String

  field :errors, types[types.String], "Reasons the object couldn't be created or updated" do
    resolve ->(obj, _args, _ctx) do
      return if obj.errors.full_messages.empty?
      raise GraphQL::ExecutionError.new(obj.errors.full_messages.join('; '))
    end
  end
end
