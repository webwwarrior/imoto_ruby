FactoryGirl.define do
  factory :photographer_attachment do
    photographer nil
    order_attribute nil
    attachment 'image.png'
    attachment_content_type 'image'
  end
end
