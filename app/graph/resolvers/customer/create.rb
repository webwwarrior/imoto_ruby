module Resolvers::Customer
  class Create < Resolvers::Base
    def call(_object, inputs, context)
      @customer = ::Customer.new(formatted_hash(inputs.to_h.except('company_id'), context))
      add_company_to_customer(inputs)
      context[:helpers][:sign_in].call(@customer) if @customer.save

      { customer: @customer }
    end

    def add_company_to_customer(inputs)
      return unless inputs['role'] == 'agent' && inputs['company_id'].present?
      @customer.company = Company.find(inputs['company_id'])
    end
  end
end
