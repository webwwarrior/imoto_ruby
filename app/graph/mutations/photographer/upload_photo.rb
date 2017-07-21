module Mutations::Photographer
  UploadPhoto = GraphQL::Relay::Mutation.define do
    name 'UploadPhoto'
    description 'Upload Photos to Order Attribute'
    input_field :order_attribute_id, !types.ID
    input_field :photo,              !types.String

    return_field :photo,             PhotographerAttachmentType

    resolve Resolvers::Photographer::UploadPhoto.new
  end
end
