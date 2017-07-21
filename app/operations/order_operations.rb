class OrderOperations
  def self.index(params, _order)
    return Order.all if params['search'].blank?
    id, name = split_search(params['search'])
    Order.by_id_and_customer_name(id, name)
  end

  def self.update(params)
    order = Order.find(params[:id])
    event_started_at = "#{params[:date]} #{params[:preferred_time].split(' ').first}".to_datetime
    order.update(event_started_at: event_started_at, travel_costs: params[:travel_costs],
                 photographer_id: params[:photographer_id])
    message = order.valid? ? 'Order was successfully updated' : 'Order was didn`t updated'
    [order, message]
  end

  def self.destroy(id)
    order = Order.find(id)
    order.update(photographer_id: nil, travel_costs: 0.00, event_started_at: nil) unless order.completed?
    message = order.completed? ? 'Order was completed, remove photographer impossible' : 'Photographer was removed'
    [order, message]
  end

  def self.split_search(search)
    id   = search.gsub(/[^0-9]/, '')
    name = search.gsub(/[^A-z]/, ' ').split.join(' ')
    [id, name]
  end

  private_class_method :split_search
end
