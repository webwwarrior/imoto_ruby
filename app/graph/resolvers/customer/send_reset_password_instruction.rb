module Resolvers::Customer
  class SendResetPasswordInstruction
    def call(_object, inputs, _context)
      customer = ::Customer.find_by(email: inputs['email'])

      raise GraphQL::ExecutionError.new("Can not find user with email #{inputs['email']}") unless customer.present?
      customer = ::Customer.send_reset_password_instructions(email: inputs['email'])

      { customer: customer }
    end
  end
end
