require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject { create(:transaction) }

  describe "associations" do
    it { is_expected.to belong_to(:account) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:account) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:volume) }
    it { is_expected.to allow_value('bid').for(:instruction) }
    it { is_expected.to allow_value('ask').for(:instruction) }
    it { is_expected.not_to allow_value('foo').for(:instruction) }
  end
end
