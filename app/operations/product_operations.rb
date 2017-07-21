class ProductOperations < BaseOperations
  def self.update(product_id, params)
    product = Product.find(product_id)
    params = prepare_for_delete(:attribute_items, product, params)
    product.update(params)
    product
  end
end
