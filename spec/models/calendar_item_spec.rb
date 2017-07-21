require 'rails_helper'

describe CalendarItem do
  it { is_expected.to belong_to :photographer }

  it { is_expected.to define_enum_for(:kind).with([:scheduled, :unavailable]) }
end
