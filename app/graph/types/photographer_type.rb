PhotographerType = GraphQL::ObjectType.define do
  name 'Photographer'
  description 'An user entry, returns basic user information'

  field :id,                    types.ID,      'This id of this user'
  field :email,                 !types.String, 'The email of this user'
  field :first_name,            types.String
  field :last_name,             types.String
  field :full_name,             types.String
  field :avatar,                types.String
  field :phone,                 types.String
  field :created_at,            types.String, 'The date this user created an account'
  field :total_orders_count,    types.Int
  field :uploaded_orders_count, types.Int

  field :photo_shoot_today_count, types.Int do
    resolve ->(obj, _args, _ctx) do
      OrderAttribute.by_photographer_day(obj, Time.now).select(:data).sum do |attribute|
        attribute.data.values.map(&:to_i).sum
      end
    end
  end
  field :photo_shoot_completed_count, types.Int do
    resolve ->(obj, _args, _ctx) { PhotographerAttachment.count_by_photographer_day(obj, Time.now) }
  end

  field :earnings, types.Float do
    resolve ->(obj, _args, _ctx) { obj.orders.total_price }
  end

  field :available_ranges, types[types.String], 'Time ranges when photographer is available' do
    resolve ->(obj, _args, _ctx) { obj.available_ranges }
  end

  field :errors, types[types.String], "Reasons the object couldn't be created or updated" do
    resolve ->(obj, _args, _ctx) do
      return if obj.errors.full_messages.empty?
      raise GraphQL::ExecutionError.new(obj.errors.full_messages.join('; '))
    end
  end
end
