module Resolvers::Photographer
  class UploadPhoto < Resolvers::Base
    def call(_object, inputs, context)
      photographer = context[:current_user]
      unless photographer.is_a?(::Photographer)
        raise GraphQL::ExecutionError.new('You need to sign in or sign up before continuing')
      end

      order_attribute = OrderAttribute.find(inputs['order_attribute_id'])
      photo = context[:attachments][:photo]

      attachment = photographer.attachments.create!(attachment: photo, order_attribute: order_attribute)

      { photo: attachment }
    end
  end
end
