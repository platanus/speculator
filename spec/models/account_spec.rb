require 'rails_helper'

RSpec.describe Account, type: :model do

  subject { create(:account, new_credentials: 'foo: bar') }

  describe "associations" do
    it { is_expected.to belong_to(:robot) }
    it { is_expected.to have_many(:orders) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:robot) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:exchange) }
    it { is_expected.to validate_presence_of(:base_currency) }
    it { is_expected.to validate_presence_of(:quote_currency) }
    it { is_expected.to allow_value('foo: bar').for(:new_credentials) }
    it { is_expected.not_to allow_value('-- anyyaml').for(:new_credentials) }
  end

  describe "parsed_credential" do
    it { expect(subject.parsed_credentials).to be_a Hash }
    it { expect(subject.parsed_credentials[:foo]).to eq 'bar' }
  end

end
