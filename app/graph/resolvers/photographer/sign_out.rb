module Resolvers::Photographer
  class SignOut
    def call(_object, _inputs, context)
      photographer = context[:current_user]

      raise GraphQL::ExecutionError.new('User have been logout already') unless photographer.is_a?(::Photographer)
      context[:helpers][:sign_out].call(photographer)
      { id: photographer.id }
    end
  end
end
