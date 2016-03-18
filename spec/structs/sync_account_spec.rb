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

  describe "bid" do
    it { expect { subject.bid(1.0, 100_000) }.to change { subject.core_account.backend.bids.count }.by(1) }
    it { expect { subject.bid(1.0, 100_000) }.to change { account.orders.count }.by(1) }
  end

  describe "ask" do
    it { expect { subject.ask(1.0, 100_000) }.to change { subject.core_account.backend.asks.count }.by(1) }
    it { expect { subject.ask(1.0, 100_000) }.to change { account.orders.count }.by(1) }
  end

  context "when some orders have been created" do
    before do
      subject.ask(1.0, 90_000)
      subject.bid(1.0, 100_000)
      subject.bid(2.0, 110_000)
      subject.bid(3.0, 112_000).cancel!
    end

    describe "orders" do
      it { expect(subject.orders.first).to be_a SyncOrder }
      it { expect(subject.orders.count).to eq 4 }
      it { expect(subject.orders(instruction: :bid).count).to eq 3 }
      it { expect(subject.orders(open: true).count).to eq 3 }
      it { expect(subject.orders(instruction: :bid, open: true).count).to eq 2 }
    end

    context "and some of them executed" do
      before do
        subject.core_account.backend.simulate_sell(100_000, 2.5)
        subject.refresh_open_orders!
      end

      describe "unsynced_volume" do
        it { expect(subject.unsynced_volume).to eq(2.5) }
      end

      describe "sync_volume" do
        it { expect(subject.sync_volume(2.5)).to eq(0.0) }
        it { expect(subject.sync_volume(3.5)).to eq(1.0) }
        it { expect { subject.sync_volume(2.5) }.to change { account.orders.unsynced.count }.by(-2) }
      end
    end
  end
end
