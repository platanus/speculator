require 'rails_helper'

RSpec.describe Account, type: :model do

  let(:credentials) { "base: BTC\nquote: CLP\nbase_balance: 10.0\nquote_balance: 10000000.0" } # used by fake backend as configuration

  subject { create(:account, exchange: 'fake', base_currency: 'BTC', quote_currency: "CLP", credentials: credentials) }

  describe "associations" do
    it { is_expected.to belong_to(:robot) }
    it { is_expected.to have_many(:orders) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:exchange) }
    it { is_expected.to validate_presence_of(:base_currency) }
    it { is_expected.to validate_presence_of(:quote_currency) }
    it { is_expected.to allow_value('foo: bar').for(:credentials) }
    it { is_expected.not_to allow_value('-- anyyaml').for(:credentials) }
  end

  describe "pair" do
    it { expect(subject.pair).to eq Trader::CurrencyPair.for_code(:BTC, :CLP) }
  end

  describe "parsed_credential" do
    it { expect(subject.parsed_credentials).to be_a Hash }
    it { expect(subject.parsed_credentials['base']).to eq 'BTC' }
  end

  describe "base_balance" do
    it { expect(subject.base_balance).to be_a Trader::Balance }
    it { expect(subject.base_balance.amount).to eq(10.0) }
  end

  describe "quote_balance" do
    it { expect(subject.quote_balance).to be_a Trader::Balance }
    it { expect(subject.quote_balance.amount).to eq(10000000.0) }
  end

end
