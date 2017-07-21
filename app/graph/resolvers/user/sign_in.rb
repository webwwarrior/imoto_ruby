module Resolvers::User
  class SignIn
    def call(_object, inputs, context)
      user = Customer.find_for_database_authentication(email: inputs['email']) ||
             Photographer.find_for_database_authentication(email: inputs['email'])

      authorized = user&.valid_password?(inputs['password'])

      unless authorized
        raise GraphQL::ExecutionError.new('Invalid email or password')
      end

      context[:helpers][:sign_in].call(user)
      { user: user }
    end
  end
end
