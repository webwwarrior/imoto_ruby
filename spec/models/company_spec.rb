require 'rails_helper'

describe Company do
  it { is_expected.to have_many(:customers) }
  it { is_expected.to have_many(:coupons).dependent(:destroy) }
  it { is_expected.to have_many(:attribute_items).dependent(:destroy) }

  it { is_expected.to validate_presence_of :name }

  it 'initialize status as pending' do
    company = Company.create!(name: 'Google', office_branch: 'Mountain View')
    expect(company.status).to eq('pending')
  end

  it 'avoid office branch name duplication' do
    Company.create(name: 'Apple', office_branch: 'Palo Alto')
    company2 = Company.create(name: 'Apple', office_branch: 'New York')
    company3 = Company.create(name: 'Apple', office_branch: 'Palo Alto')

    expect(company2.persisted?).to be_truthy
    expect(company3.persisted?).to be_falsey
    expect(company3.errors.details[:office_branch][0][:error]).to eq(:taken)
  end
end
