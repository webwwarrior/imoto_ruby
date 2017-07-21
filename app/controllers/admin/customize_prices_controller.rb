class Admin::CustomizePricesController < Admin::BaseController
  before_action :set_company
  before_action :set_attribute, only: [:edit, :update, :destroy]

  def edit
  end

  def create
    attribute = CustomizePriceOperations.create(params[:item_id], @company)
    flash[:notice] = attribute.errors.full_messages if attribute.invalid?
    redirect_to admin_company_path(@company)
  end

  def update
    @attribute.update(attribute_params)
  end

  def destroy
    @attribute.destroy
    redirect_to admin_company_path(@company)
  end

  private

  def attribute_params
    params.permit(:base_price, :additional_price)
  end

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_attribute
    @attribute = @company.attribute_items.find(params[:id])
  end
end
