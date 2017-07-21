require 'rails_helper'

describe Coupon do
  it { is_expected.to define_enum_for(:status).with([:enabled, :disabled]) }
  it { is_expected.to define_enum_for(:discount_type).with([:percentage, :flat_amount]) }
  it { is_expected.to belong_to :company }
  it { is_expected.to have_many :orders }
  it { is_expected.to have_and_belong_to_many :customers }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_presence_of :discount_amount }
  it { is_expected.to validate_numericality_of(:discount_amount).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:minimum_purchase).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:max_uses_per_user).is_greater_than_or_equal_to(1) }
  it { is_expected.to validate_numericality_of(:max_uses).is_greater_than_or_equal_to(1) }

  describe '#active?' do
    before { travel_to Date.new(2004, 01, 01) }
    after  { travel_back }

    context 'invalid date' do
      let!(:coupon1) { create :coupon, start_date: Date.new(2004, 01, 14), expiration_date: Date.new(2004, 01, 24) }
      let!(:coupon2) { create :coupon, start_date: Date.new(2003, 12, 31), expiration_date: Date.new(2004, 01, 24) }
      let!(:coupon3) { create :coupon, start_date: Date.new(2004, 01, 01), expiration_date: Date.new(2004, 01, 20) }
      let!(:coupon4) { create :coupon, start_date: Date.new(2003, 12, 31), expiration_date: Date.new(2004, 01, 20) }
      let!(:coupon5) { create :coupon, start_date: Date.new(2003, 12, 20), expiration_date: Date.new(2003, 12, 31) }

      specify do
        expect(coupon1.active?).to eq false
        expect(coupon2.active?).to eq true
        expect(coupon3.active?).to eq true
        expect(coupon4.active?).to eq true
        expect(coupon5.active?).to eq false
      end
    end

    context 'coupon usage count' do
      let!(:coupon1) do
        create :coupon, start_date: Date.new(2003, 01, 14), expiration_date: Date.new(2004, 02, 24),
                        track_coupon_usage: 1, max_uses: 1
      end
      let!(:coupon2) do
        create :coupon, start_date: Date.new(2003, 12, 31), expiration_date: Date.new(2004, 02, 24),
                        track_coupon_usage: 1, max_uses: 3
      end

      specify do
        expect(coupon1.active?).to eq false
        expect(coupon2.active?).to eq true
      end
    end
  end
end
