module Resolvers::Order
  class UpdateStatus < Resolvers::Base
    def call(_object, inputs, _context)
      order = ::Order.find(inputs.to_h['order_id'])
      order.status = inputs.to_h['status']

      unless order.save
        raise GraphQL::ExecutionError.new("Invalid input for Order: #{order.errors.full_messages.join(', ')}")
      end

      { status: order.status }
    end
  end
end
