require 'rails_helper'

RSpec.describe PhotographerAttribute, type: :model do
  it { is_expected.to belong_to :attribute_item }
  it { is_expected.to belong_to :photographer }

  it { is_expected.to validate_numericality_of(:default_time).is_greater_than_or_equal_to(1) }
end
