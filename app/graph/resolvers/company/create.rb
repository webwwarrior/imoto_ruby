module Resolvers::Company
  class Create < Resolvers::Base
    def call(_object, inputs, context)
      @company = ::Company.new(formatted_hash(inputs.to_h, context))
      @company.save

      { company: @company }
    end
  end
end
