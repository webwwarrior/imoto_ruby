module Resolvers::Customer
  class DeleteOrder
    def call(_object, inputs, context)
      customer = context[:current_user]
      raise GraphQL::ExecutionError.new('You are not authorized') unless customer.is_a?(::Customer)

      order = customer.orders.find(inputs.to_h['id'])
      { status: 'Order have been successfully deleted' } if order.destroy
    end
  end
end
