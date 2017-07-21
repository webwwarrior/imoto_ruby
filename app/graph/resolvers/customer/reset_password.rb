module Resolvers::Customer
  class ResetPassword
    def call(_object, inputs, _context)
      customer = ::Customer.with_reset_password_token(inputs['reset_password_token'])

      raise GraphQL::ExecutionError.new('Invalid reset password token') unless customer.present?

      unless customer.reset_password(inputs['password'], inputs['password_confirmation'])
        raise GraphQL::ExecutionError.new('Your password and password confirmation do not coincide')
      end

      { customer: customer }
    end
  end
end
