require 'rails_helper'

RSpec.describe Order, type: :model do

  subject { create(:order) }

  describe "associations" do
    it { is_expected.to belong_to(:account) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:ex_id) }
    it { is_expected.to validate_presence_of(:volume) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:base_currency) }
    it { is_expected.to validate_presence_of(:quote_currency) }
  end

  describe "pending_volume" do
    it { expect(create(:order, volume: 1.0, pending_volume: nil).pending_volume).to eq(1.0) }
  end

  describe "unsynced_volume" do
    it { expect(create(:order, volume: 1.0, pending_volume: nil).unsynced_volume).to eq(0.0) }
    it { expect(create(:order, volume: 1.0, pending_volume: 0.5).unsynced_volume).to eq(0.5) }
  end

end
