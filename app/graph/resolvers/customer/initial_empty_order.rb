module Resolvers::Customer
  class InitialEmptyOrder
    def call(_object, _inputs, context)
      customer = context[:current_user]
      raise GraphQL::ExecutionError.new('You are not authorized') unless customer.is_a?(::Customer)
      { order: customer.orders.create }
    end
  end
end
