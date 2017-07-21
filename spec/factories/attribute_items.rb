FactoryGirl.define do
  factory :attribute_item do
    company
    product
    base_price          { 100 }
    base_quantity       { 25 }
    additional_price    { 2.5 }

    trait :dependent_select do
      kind { 'dependent_select' }
      data do
        {
          'quantity_range' => %w(1 10), 'main_select_label' => 'Photo', 'subselect_labels' => %w(Room Bedroom Bathroom)
        }
      end
    end

    trait :single_select do
      kind { 'single_select' }
      data { { '25' => '25 Photos', '35' => '35 Photos', '45' => '45 Photos' } }
    end

    trait :input do
      kind { 'input' }
      data { { 'unit' => '2500 sq/ft', 'note' => 'square footage', 'kind' => 'text' } }
    end

    trait :upload do
      kind { 'upload' }
      data { { 'extensions' => %w(png pdf jpg) } }
    end

    trait :switch do
      kind { 'switch' }
      data { { 'label' => 'Branded Tour', 'description' => 'Description' } }
    end

    trait :tags do
      kind { 'tags' }
      data { { 'placeholder' => 'Garage' } }
    end

    trait :hidden do
      kind { 'hidden' }
      data { {} }
    end

    trait :order_details do
      kind { 'order_details' }
      data { {} }
    end
  end
end
