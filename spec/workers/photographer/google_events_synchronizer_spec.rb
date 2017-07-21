require 'rails_helper'

describe Photographer::GoogleEventsSynchronizer do
  let(:photographer) { create :photographer }

  specify do
    expect { described_class.perform_async(photographer.id) }.to change(described_class.jobs, :size).by(1)
  end
end
