class Admin::CustomersController < Admin::BaseController
  def destroy
    if requested_resource.orders_not_completed.blank?
      requested_resource.destroy
      flash[:notice] = translate_with_resource('destroy.success')
    else
      flash[:notice] = 'You can`t remove a customer unless orders is completed'
    end
    redirect_to action: :index
  end
end
