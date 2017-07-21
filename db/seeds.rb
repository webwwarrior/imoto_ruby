Photographer.destroy_all
Customer.destroy_all
Admin.destroy_all
Admin.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
puts 'ADMIN: admin@example.com/password'

zip_code1 = ZipCode.create!(value: 339_35, state_code: 'FL', state_name: 'Florida', city: 'Labelle',
                            time_zone: 'America/New_York')
zip_code2 = ZipCode.create!(value: 605_54, state_code: 'IL', state_name: 'Illinois', city: 'Sugar Grove',
                            time_zone: 'America/Chicago')

photographer = zip_code1.photographers.create!(
  email: 'photographer@example.com', password: 'password', password_confirmation: 'password',
  default_time_zone: 'America/New_York', start_work_at: '08:00:00', end_work_at: '22:00:00'
)
puts 'PHOTOGRAPHER: photographer@example.com/password'

photographer2 = zip_code1.photographers.create!(
  email: 'photographer2@example.com', password: 'password', password_confirmation: 'password',
  default_time_zone: 'America/New_York', start_work_at: '08:00:00', end_work_at: '21:00:00'
)
photographer3 = zip_code2.photographers.create!(
  email: 'photographer3@example.com', password: 'password', password_confirmation: 'password',
  default_time_zone: 'America/New_York', start_work_at: '09:00:00', end_work_at: '19:30:00'
)
company = Company.create!(name: 'Company')

customer = Customer.create!(
  email: 'customer@example.com', password: 'password', password_confirmation: 'password', role: :agent, company: company
)
puts 'CUSTOMER: customer@example.com/password'

CalendarItem.create!(
  photographer:     photographer,
  unavailable_from: DateTime.new(2016, 10, 21, 7, 00, 00),
  unavailable_to:   DateTime.new(2016, 10, 21, 8, 00, 00)
)
CalendarItem.create!(
  photographer:     photographer,
  unavailable_from: DateTime.new(2016, 10, 21, 9, 00, 00),
  unavailable_to:   DateTime.new(2016, 10, 21, 10, 00, 00)
)
CalendarItem.create!(
  photographer:     photographer,
  unavailable_from: DateTime.new(2016, 10, 21, 14, 00, 00),
  unavailable_to:   DateTime.new(2016, 10, 21, 15, 30, 00)
)
CalendarItem.create!(
  photographer:     photographer2,
  unavailable_from: DateTime.new(2016, 10, 21, 15, 00, 00),
  unavailable_to:   DateTime.new(2016, 10, 21, 16, 00, 00)
)
CalendarItem.create!(
  photographer:     photographer3,
  unavailable_from: DateTime.new(2016, 10, 21, 9, 00, 00),
  unavailable_to:   DateTime.new(2016, 10, 21, 10, 00, 00)
)

Category.create!(name: 'Photos')
Category.create!(name: 'Videos')

coupon = Coupon.create!(
  company:           company,
  name:              'Coupon Name',
  code:              '123a',
  max_uses:          1,
  max_uses_per_user: 1,
  start_date:        '2016-12-30',
  expiration_date:   '2017-01-30',
  minimum_purchase:  140.00,
  discount_amount:   10
)

order = Order.create!(
  address:             'Shevchenko avenue 3',
  city:                'Florida',
  state:               'FL',
  zip_code:            '33935',
  listing_price:       1000.56,
  square_footage:      600.43,
  number_of_beds:      4,
  number_of_baths:     2.5,
  listing_description: 'New appartment',
  additional_notes:    'for sale',
  photographer_id:     photographer.id,
  customer_id:         customer.id,
  event_started_at:    DateTime.new(2017, 3, 21, 7, 00, 00),
  coupon:              coupon
)

product1 = FactoryGirl.create(:product, name: 'Photo Shoot', description: 'description 1', sku: 'A123')
attribute1 = product1.attribute_items.create(
  base_price: 10,
  base_quantity: 25,
  additional_price: 5,
  kind: :single_select,
  data: { quantity: %w(25 35 45), label: ['25 Photos', '35 Photos', '45 Photos'] }
)
# result of data is { '25' => '25 Photos', '35' => '35 Photos', '45' => '45 Photos' }

# create customized attribute for company
product1.attribute_items.create!(
  parent_id: attribute1.id,
  company: company,
  base_price: 2,
  base_quantity: 25,
  additional_price: 1,
  kind: :single_select,
  data: { quantity: %w(50 60 70), label: ['25 Photos', '35 Photos', '45 Photos'] }
)
# result of data is { '50' => '25 Photos', '60' => '35 Photos', '70' => '45 Photos' }

product2 = FactoryGirl.create(:product, name: 'Virtual Staging', description: 'description 2', sku: 'B123')
attribute2 = product2.attribute_items.create(
  base_price: 5,
  base_quantity: 1,
  additional_price: 5,
  kind: :dependent_select,
  data: { 'quantity_range' => %w(1 10), 'main_select_label' => 'Photo',
          'subselect_labels' => %w(Room Bedroom Bathroom) }
)

product3 = FactoryGirl.create(:product, name: 'Floor Plan', description: 'description 3', sku: 'C123')
attribute3 = product3.attribute_items.create(
  base_price: 1000,
  base_quantity: 1,
  additional_price: 500,
  kind: :input,
  data: { 'unit' => '2500 sq/ft', 'note' => 'square footage', kind: 'float' }
)

product3.attribute_items.create!(
  base_price: 80,
  base_quantity: 1000,
  additional_price: 40,
  kind: :input,
  data: { 'unit' => '100 sq/ft', 'note' => 'square footage', kind: 'text' }
)

# create customized attributes for company
product3.attribute_items.create!(
  parent_id: attribute3.id,
  company: company,
  base_price: 150,
  base_quantity: 2000,
  additional_price: 100,
  kind: :input,
  data: { 'unit' => '2000 sq/ft', 'note' => 'square footage', kind: 'integer' }
)

product4 = FactoryGirl.create(:product, name: 'DIY Floor Plan', description: 'description 4', sku: 'D123')
product4.attribute_items.create(
  base_price: 100,
  base_quantity: 1,
  additional_price: 10,
  kind: :upload,
  data: { 'extensions' => %w(png pdf jpg) }
)

product5 = FactoryGirl.create(:product, name: 'Twilight', description: 'description 5', sku: 'E123')
product5.attribute_items.create(
  base_price: 1,
  base_quantity: 25,
  additional_price: 1,
  kind: :single_select,
  data: { quantity: %w(25 35 45), label: ['25 Photos', '35 Photos', '45 Photos'] }
)
# result of data is { '25' => '25 Photos', '35' => '35 Photos', '45' => '45 Photos' }

product6 = FactoryGirl.create(:product, name: '3D Showcase', description: 'description 6', sku: 'F123')
product6.attribute_items.create(
  base_price: 100,
  base_quantity: 1,
  additional_price: 0,
  kind: :hidden
)

product7 = FactoryGirl.create(:product, name: 'Listing Teaser', description: 'description 7', sku: 'G123')
product7.attribute_items.create(
  base_price: 100,
  base_quantity: 1,
  additional_price: 10,
  kind: :hidden
)

product8 = FactoryGirl.create(:product, name: 'More/Add-ons', description: 'description 8', sku: 'H123')
product8.attribute_items.create(
  base_price: 100,
  base_quantity: 1,
  additional_price: 0,
  kind: :switch,
  data: { 'label' => 'Extended Hosting', 'description' => 'Description' }
)
product8.attribute_items.create!(
  base_price: 100,
  base_quantity: 1,
  additional_price: 0,
  kind: :switch,
  data: { 'label' => 'Branded Tour', 'description' => 'Description' }
)

product9 = FactoryGirl.create(:product, name: 'Video')
product9.attribute_items.create(
  base_price: 100,
  base_quantity: 1,
  additional_price: 0,
  kind: :order_details
)
product9.attribute_items.create!(
  base_price: 10,
  base_quantity: 1,
  additional_price: 0,
  kind: :tags, # Garage, Pool i.e.
  data: { 'placeholder' => 'Add Extra Feature' }
)

order.order_attributes.create!(
  attribute_item: attribute1,
  quantity: 35,
  price: 60, # (10$ + 5 * 10$)
  name: 'Photo Shoot'
)

order.order_attributes.create!(
  attribute_item: attribute2,
  quantity: 45,
  price: 45, # (25$ + 20 * 1$)
  name: 'Virtual Staging'
)

order.order_attributes.create!(
  attribute_item: attribute3,
  quantity: 1,
  price: 1000,
  name: 'Floor Plan'
)

Product.find_each { |product| OrdersProduct.create!(order: order, product: product) }

photographer.photographer_attributes.create!(attribute_item: attribute1, default_time: 30, extra_time: 5)
photographer.photographer_attributes.create!(attribute_item: attribute2, default_time: 90, extra_time: 30)
photographer.photographer_attributes.create!(attribute_item: attribute3, default_time: 45, extra_time: 30)

photographer2.photographer_attributes.create!(attribute_item: attribute1, default_time: 30, extra_time: 5)
photographer2.photographer_attributes.create!(attribute_item: attribute2, default_time: 90, extra_time: 30)
photographer2.photographer_attributes.create!(attribute_item: attribute3, default_time: 45, extra_time: 30)
