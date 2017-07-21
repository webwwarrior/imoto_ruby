require 'rails_helper'

describe ContactRequest do
  it { is_expected.to validate_presence_of :sender_email }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :subject }
end
