module Resolvers::Customer
  class ProductOrderDetails < Resolvers::Base
    def call(_object, inputs, context)
      raise GraphQL::ExecutionError.new('You are not authorized') unless context[:current_user].is_a?(::Customer)

      @order = Order.find(inputs.to_h['order_id'])
      { order: update_order_details(inputs.to_h, context) }
    end

    private

    def update_order_details(params, context)
      new_order_attributes(formatted_hash(params['attributes'], context))

      raise GraphQL::ExecutionError.new(@order.errors.full_messages.join(', ')) unless @order.valid?

      @order.update(step: :products_selection, active_step: params['active_step'],
                    current_step: params['current_step'])
      @order
    end

    def new_order_attributes(attributes_params)
      @order.order_attributes.destroy_all if @order.order_attributes.any?
      attributes_params.each do |selected_attribute|
        attribute = AttributeItem.find(selected_attribute['id'])
        build_order_attribute(selected_attribute, attribute)
      end
    end

    def build_order_attribute(parameters, attribute)
      quantity = unit_quantity(parameters, attribute)
      data     = input_data(parameters, attribute)

      raise GraphQL::ExecutionError.new('Invalid product quantity') if quantity < attribute.base_quantity

      @order.order_attributes.build(
        parameters.slice('quantity')
                  .merge(data: data, name: attribute.name, attribute_item: attribute, document: parameters['document'],
                         price: attribute.total_price(quantity))
      )
    end

    def unit_quantity(parameters, attribute)
      attribute.input? ? parameters['data'].first['value'].to_i : parameters['quantity'].to_i
    end

    def input_data(parameters, attribute)
      return {} unless parameters['data'].present?
      return parameters['data'].map { |hash| hash['value'] } if attribute.tags?
      parameters['data'].each_with_object({}) do |hash, result|
        key = attribute.input? ? attribute['data']['note'] : hash['key']
        result[key] = hash['value']
      end
    end
  end
end
