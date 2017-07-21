class Admin::OrderAttributesController < Admin::BaseController
  def destroy
    order = Order.find(params[:id])
    order.order_attributes.find(params[:attribute_id]).destroy if order.photographer.blank?
    redirect_to admin_order_path(order)
  end
end
