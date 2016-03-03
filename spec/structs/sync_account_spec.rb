require 'rails_helper'

RSpec.describe SyncAccount do

  let(:credentials) { "base: BTC\nquote: CLP\nbase_balance: 10.0\nquote_balance: 10000000.0" } # used by fake backend as configuration
  let(:account) { create(:account, exchange: 'fake', base_currency: 'BTC', quote_currency: "CLP", credentials: credentials) }

  subject { described_class.new account }

  describe "pair" do
    it { expect(subject.pair).to eq Trader::CurrencyPair.for_code(:BTC, :CLP) }
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
