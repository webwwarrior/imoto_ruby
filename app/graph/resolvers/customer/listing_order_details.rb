module Resolvers::Customer
  class ListingOrderDetails
    def call(_object, inputs, context)
      raise GraphQL::ExecutionError.new('You are not authorized') unless context[:current_user].is_a?(::Customer)
      { order: update_listing_details(inputs) }
    end

    private

    def update_listing_details(inputs)
      order = Order.find(inputs.to_h['id'])
      unless order.update(inputs.to_h.except('id').merge(step: :listing_confirmation))
        raise GraphQL::ExecutionError.new("Invalid input for Order: #{order.errors.full_messages.join(', ')}")
      end
      order
    end
  end
end
