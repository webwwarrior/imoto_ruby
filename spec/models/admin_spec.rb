require 'rails_helper'

describe Admin do
  it { is_expected.to validate_presence_of :email }
end
