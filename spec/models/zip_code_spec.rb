require 'rails_helper'

describe ZipCode do
  it { is_expected.to have_and_belong_to_many(:photographers) }
end
