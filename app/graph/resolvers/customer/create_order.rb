module Resolvers::Customer
  class CreateOrder
    def call(_object, inputs, context)
      @customer = context[:current_user]
      raise GraphQL::ExecutionError.new('You are not authorized') unless @customer.is_a?(::Customer)
      { order: create_new_order(inputs) }
    end

    private

    def create_new_order(inputs)
      order = Order.new(inputs.to_h.except('products', 'coupon_value'))
      order.customer_id = @customer.id
      order.coupon = Coupon.find_by(code: inputs['coupon_value'])
      add_orders_products(order, inputs['products'])
      order.save
      order
    end

    def add_orders_products(order, products)
      products.each do |product|
        order.orders_products.new(product_id: product.to_h['id'], quantity: product.to_h['quantity'])
      end
    end
  end
end
