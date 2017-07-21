module Resolvers::Customer
  class Update < Resolvers::Base
    # rubocop:disable all
    def call(_object, inputs, context)
      @customer = context[:current_user]

      raise GraphQL::ExecutionError.new('You need to sign in or sign up before continuing') unless @customer.is_a?(::Customer)

      if inputs['password'].present? && inputs['password_confirmation'].blank?
        raise GraphQL::ExecutionError.new('Password confirmation can not be blank')
      end

      unless @customer.update(formatted_hash(inputs.to_h.except('company'), context))
        raise GraphQL::ExecutionError.new("Invalid input for Customer: #{@customer.errors.full_messages.join(', ')}")
      end

      update_company_information(inputs, context)

      { customer: @customer }
    end

    def update_company_information(inputs, context)
      company = if @customer.company.present?
        @customer.company.update(formatted_hash(inputs['company'].to_h, context))
        @customer.company
      else
        Company.find_or_initialize_by(formatted_hash(inputs['company'].to_h, context))
      end

      unless company.valid?
        raise GraphQL::ExecutionError.new("Invalid input for Company: #{company.errors.full_messages.join(', ')}")
      end

      @customer
    end
    #rubocop:enable all
  end
end
