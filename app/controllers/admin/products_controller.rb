class Admin::ProductsController < Admin::BaseController
  def create
    product = Product.create(product_params)
    respond_for(product)
  end

  def update
    product = ProductOperations.update(params[:id], product_params)
    respond_for(product)
  end

  private

  def respond_for(product)
    if product.valid?
      redirect_to([namespace, product], notice: translate_with_resource("#{action_name}.success"))
    else
      render :edit, locals: { page: Administrate::Page::Form.new(dashboard, product) }
    end
  end

  # rubocop:disable all
  def product_params
    params.require(:product).permit(:category_id, :name, :description, :sku, :status, :image,
      attribute_items_attributes: [:id, :base_price, :additional_price, :base_quantity, :kind,
      data: [:label, :description, :placeholder, :kind, :note, :unit, :note, :main_select_label, extensions: [], subselect_labels: [],
      quantity_range: [], label: [], quantity: [], price: []]])
  end
  # rubocop:enable all
end
