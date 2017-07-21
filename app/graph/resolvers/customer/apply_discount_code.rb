module Resolvers::Customer
  class ApplyDiscountCode < Resolvers::Base
    attr_reader :coupon, :order, :customer

    # rubocop:disable all
    def call(_object, inputs, context)
      assign_variables(inputs, context)

      raise GraphQL::ExecutionError.new('You are not authorized') unless customer.is_a?(::Customer)
      raise GraphQL::ExecutionError.new("Can not find coupon with discount code #{inputs.to_h['code']}") if coupon.nil?
      raise GraphQL::ExecutionError.new('You have already applied discount') if order.coupon_id.present?

      { order: assign_coupon_to_order }
    end
    # rubocop:enable all

    private

    def assign_variables(inputs, context)
      @customer = context[:current_user]
      @coupon = Coupon.enabled.find_by(code: inputs.to_h['code'])
      @order  = Order.find(inputs.to_h['order_id'])
    end

    # rubocop:disable all
    def assign_coupon_to_order
      raise GraphQL::ExecutionError.new('You have reached your limit already') unless valid_coupon_count?
      raise GraphQL::ExecutionError.new('Your coupon has been expired already') unless coupon.active?

      coupon.increment(:track_coupon_usage).save
      customer.coupons << coupon
      order.update(coupon: coupon)
      order
    end
    # rubocop:enable all

    def valid_coupon_count?
      customer.coupons.where(coupons: { id: coupon.id }).count < coupon.max_uses_per_user
    end
  end
end
