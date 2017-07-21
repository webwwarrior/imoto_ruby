class CustomizePriceOperations
  def self.create(item_id, company)
    attribute = AttributeItem.find(item_id)
    attribute_cloned = attribute.dup
    attribute_cloned.company = company
    attribute_cloned.parent_id = attribute.id
    attribute_cloned.save
    attribute_cloned
  end
end
