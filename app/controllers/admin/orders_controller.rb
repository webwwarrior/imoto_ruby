class Admin::OrdersController < Admin::BaseController
  def index
    resources = OrderOperations.index(params, order)
    resources = order.apply(resources)
    resources = resources.order(created_at: :desc).page(params[:page]).per(20)
    page      = Administrate::Page::Collection.new(OrderDashboard.new, order: order)
    render locals: { resources: resources, search_term: params['search'], page: page }
  end

  def show
    if params[:search].present?
      if params[:type] == 'name'
        first_name, last_name = params['search'].split(' ')
        photographers = Photographer.with_name(first_name, last_name).page(params[:page]).per(20)
      else
        photographers = Photographer.with_city_and_state.with_location(params[:search], params[:type])
                                    .page(params[:page]).per(20)
      end
    end

    with_time = photographers_with_time(photographers, params['date'], requested_resource)

    render locals: {
      page: Administrate::Page::Show.new(dashboard, requested_resource),
      photographers: { with_time: with_time, all: photographers }
    }
  end

  def edit
    @order = Order.find(params[:id])
    @photographer = Photographer.find(params[:photographer_id])
    time = Photographers::AvailableHours.new(@photographer, { 'date' => params[:date] }, @order).call
    @format_time = time.map { |t| format_time(t) }
    @date = params[:date]
  end

  def update
    order, message = OrderOperations.update(params)
    redirect_to admin_order_path(order), notice: message
  end

  def destroy
    order, message = OrderOperations.destroy(params[:id])
    redirect_to admin_order_path(order), notice: message
  end

  private

  def photographers_with_time(photographers, date, requested_resource)
    photographers&.map do |photographer|
      photographer_time = Photographers::AvailableHours.new(photographer, { 'date' => date }, requested_resource).call
      time = photographer_time.map { |t| format_time(t) }
      { time: time, photographer: photographer }
    end
  end

  def format_time(time)
    "#{time.first.strftime('%I:%M%p')} - #{time.last.strftime('%I:%M%p')}"
  end
end
