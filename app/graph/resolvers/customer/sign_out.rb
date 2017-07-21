module Resolvers::Customer
  class SignOut
    def call(_object, _inputs, context)
      customer = context[:current_user]

      raise GraphQL::ExecutionError.new('User have been logout already') unless customer.is_a?(::Customer)
      context[:helpers][:sign_out].call(customer)
      { id: customer.id }
    end
  end
end
