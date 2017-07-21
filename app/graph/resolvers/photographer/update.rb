module Resolvers::Photographer
  class Update < Resolvers::Base
    # rubocop:disable all
    def call(_object, inputs, context)
      photographer = context[:current_user]

      raise GraphQL::ExecutionError.new('You need to sign in or sign up before continuing') unless photographer.is_a?(::Photographer)

      if inputs['password'].present? && inputs['password_confirmation'].blank?
        raise GraphQL::ExecutionError.new('Password confirmation can not be blank')
      end

      unless photographer.update(formatted_hash(inputs.to_h, context))
        raise GraphQL::ExecutionError.new("Invalid input for Customer: #{photographer.errors.full_messages.join(', ')}")
      end

      { photographer: photographer }
    end
    #rubocop:enable all
  end
end
