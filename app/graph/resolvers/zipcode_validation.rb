module Resolvers
  class ZipcodeValidation
    def call(_object, inputs, _context)
      unless ZipCode.find_by(inputs.to_h).present?
        raise GraphQL::ExecutionError.new("Cannot find zip code #{inputs.to_h['value']} at state " \
                                          "#{inputs.to_h['state_name']}")
      end
      { status: 'valid' }
    end
  end
end
