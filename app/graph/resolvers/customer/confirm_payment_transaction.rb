module Resolvers::Customer
  class ConfirmPaymentTransaction
    def call(_object, inputs, context)
      @customer = context[:current_user]
      raise GraphQL::ExecutionError.new('You are not authorized') unless @customer.is_a?(::Customer)
      { order: update_order_details(inputs.to_h) }
    end

    private

    def update_order_details(inputs)
      order = Order.find(inputs['order_id'])
      create_payment_transaction(inputs, order)

      unless order.update(step: :confirmed)
        raise GraphQL::ExecutionError.new("Invalid input for Order: #{order.errors.full_messages.join(', ')}")
      end

      order
    end

    def create_payment_transaction(inputs, order)
      AuthorizeNet.new(@customer).capture_authorized_amount(transaction_id:   inputs['trans_id'],
                                                            amount:           order.price_with_discount,
                                                            save_credit_card: inputs['save_credit_card'])
    rescue AuthorizeNet::TransactionError => exc
      raise GraphQL::ExecutionError.new(exc.message)
    end
  end
end
