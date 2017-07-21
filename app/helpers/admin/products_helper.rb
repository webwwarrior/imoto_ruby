module Admin::ProductsHelper
  def disabled_attribute_fields(kind)
    %(hidden switch order_details tags).include?(kind) || action_name == 'show'
  end

  def selected_options(kind, item, type)
    item&.data.present? && item.data[type] == kind ? 'selected' : nil
  end
end
