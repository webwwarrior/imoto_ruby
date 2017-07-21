QueryRoot = GraphQL::ObjectType.define do
  name 'Query'

  # for example purpose
  field :photographer do
    type PhotographerType
    resolve ->(_root, _args, ctx) { ctx[:current_user] if ctx[:current_user].is_a?(Photographer) }
  end

  field :photographers do
    type !types[PhotographerType]
    argument :ids, types[types.ID], 'The IDs of the Photographers'
    resolve ->(_root, args, _ctx) { Photographer.where(id: args[:ids]) }
  end

  field :available_photographers do
    type !types[PhotographerType]
    argument :order_id, !types.ID
    argument :date,     types.String, "Input Date to search Photographers in format 'yyyy-mm-dd'"
    argument :time,     types.String, "Input Time to search Photographers in format '4:30 AM, 5:00 PM'"
    resolve ->(_root, args, ctx) do
      raise GraphQL::ExecutionError.new('You are not authorized!') unless ctx[:current_user].is_a?(Customer)
      order = ctx[:current_user].orders.find(args['order_id'])
      attribute_item_ids = order.order_attributes.parent_item_ids
      photographers ||= Photographer.with_zipcode(order.zip_code).competent(attribute_item_ids)

      unless photographers
        raise GraphQL::ExecutionError.new('No photographers is available for selected products.' \
                                          'Please contact us for more details')
      end

      photographers.map do |photographer|
        photographer.available_ranges = Photographers::AvailableHours.new(photographer, args, order).call
        photographer
      end

      unavailable = photographers.select { |user| user.available_ranges.empty? }
      available = (photographers - unavailable).sort_by { |user| user.available_ranges.first.first.to_i }
      available + unavailable
    end
  end

  field :products_with_attributes do
    type !types[ProductType]
    resolve ->(_root, _args, ctx) do
      raise GraphQL::ExecutionError.new('You are not authorized!') unless ctx[:current_user].is_a?(Customer)
      Product.enabled
    end
  end

  field :customer_orders do
    type !types[OrderType]
    resolve ->(_root, _args, ctx) do
      raise GraphQL::ExecutionError.new('You are not authorized!') unless ctx[:current_user].is_a?(Customer)
      ctx[:current_user].orders
    end
  end

  field :photographer_orders do
    type !types[OrderType]
    resolve ->(_root, _args, ctx) do
      raise GraphQL::ExecutionError.new('You are not authorized!') unless ctx[:current_user].is_a?(Photographer)
      ctx[:current_user].orders
    end
  end

  field :order do
    type OrderType
    argument :id, !types.ID
    resolve ->(_root, args, ctx) do
      raise GraphQL::ExecutionError.new('You are not authorized!') unless ctx[:current_user].is_a?(Customer) || ctx[:current_user].is_a?(Photographer)
      ctx[:current_user].orders.find(args[:id])
    end
  end

  field :customer do
    type CustomerType
    resolve ->(_root, _args, ctx) { ctx[:current_user] if ctx[:current_user].is_a?(Customer) }
  end

  field :companies do
    type !types[CompanyType]
    resolve ->(_root, _args, _ctx) { Company.active }
  end

  field :company_branches do
    type !types[CompanyType]
    argument :company_name, !types.String
    resolve ->(_root, args, ctx) do
      Company.where(name: args[:company_name])
    end
  end

  field :list_of_credit_cards do
    type !types[CreditCardType]
    resolve ->(_root, _args, ctx) do
      raise GraphQL::ExecutionError.new('You are not authorized!') unless ctx[:current_user].is_a?(Customer)
      ctx[:current_user].credit_cards
    end
  end

  field :photographer_calendar_items do
    type !types[CalendarItemType]
    resolve ->(_root, _args, ctx) do
      raise GraphQL::ExecutionError.new('You are not authorized!') unless ctx[:current_user].is_a?(Photographer)
      ctx[:current_user].calendar_items
    end
  end
end
