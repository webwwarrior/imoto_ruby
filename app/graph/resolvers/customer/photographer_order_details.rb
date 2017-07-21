module Resolvers::Customer
  class PhotographerOrderDetails
    def call(_object, inputs, context)
      raise GraphQL::ExecutionError.new('You are not authorized') unless context[:current_user].is_a?(::Customer)
      { order: update_photographer_details(inputs) }
    end

    private

    def update_photographer_details(inputs)
      @order = Order.find(inputs.to_h['order_id'])

      unless @order.update(parameters(inputs.to_h))
        raise GraphQL::ExecutionError.new("Invalid input for Order: #{@order.errors.full_messages.join(', ')}")
      end

      setup_estimated_time_for_attributes
      @order
    end

    def parameters(inputs)
      {
        event_started_at: DateTime.parse(inputs['time_range'].split('..').first),
        photographer_id:  inputs['photographer_id'],
        active_step:      inputs['active_step'],
        current_step:     inputs['current_step'],
        special_request:  inputs['special_request'],
        step: :photographer_selection
      }
    end

    def setup_estimated_time_for_attributes
      @order.order_attributes.each do |order_attr|
        attr_item = parent_attribute(order_attr)
        ph_attr = photographer_attributes.find_by(attribute_item_id: attr_item.id)

        time = ph_attr.default_time + (order_attr.quantity - attr_item.base_quantity) * ph_attr.extra_time
        order_attr.update(estimated_time: time)
      end
    end

    def photographer_attributes
      @ph_attrs ||= @order.photographer.photographer_attributes
                          .where(attribute_item_id: @order.order_attributes.parent_item_ids)
    end

    def parent_attribute(order_attribute)
      return order_attribute.attribute_item if order_attribute.attribute_item.parent_id.nil?
      AttributeItem.find(order_attribute.attribute_item.parent_id)
    end
  end
end
