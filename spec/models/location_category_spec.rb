require 'rails_helper'

RSpec.describe LocationCategory, type: :model do

  it 'has a valid factory' do
    expect(build_stubbed(:location_category)).to be_valid
  end

  describe 'associations' do
    let(:location_category) { build_stubbed(:location_category) }

    it 'has meetings' do
      expect(location_category).to respond_to(:meetings)
    end

    it 'has locations' do
      expect(location_category).to respond_to(:locations)
    end
  end

  describe 'attributes' do
    let(:location_category) { build(:location_category) }

    it 'has context' do
      expect(location_category).to respond_to(:context)
    end
  end
end
