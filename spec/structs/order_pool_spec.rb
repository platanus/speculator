require 'rails_helper'

describe OrderPool do

  let(:credentials) { "base: BTC\nquote: CLP\nbase_balance: 10.0\nquote_balance: 1000000.0" } # used by fake backend as configuration
  let(:raw_account) { create(:account, exchange: 'fake', base_currency: 'BTC', quote_currency: "CLP", new_credentials: credentials) }
  let(:account) { SyncAccount.new raw_account }
  let(:backend) { account.core_account.backend }

  let(:btc) { Trader::Currency.for_code(:BTC) }
  let(:clp) { Trader::Currency.for_code(:CLP) }
  let(:pair) { Trader::CurrencyPair.new btc, clp }
  # let(:backend) { Trader::FakeBackend.new pair, 10.0, 1_000_000.0 }

  let(:pool) { described_class.new account, :ask, price_thr: 0.01, volume_thr: 0.1 }

  let(:first_wave) {
    [
      Trader::Order.new_ask(pair, 9.5, 300_000.0),
      Trader::Order.new_ask(pair, 1.0, 305_000.0)
    ]
  }

  let(:second_wave) {
    [
      Trader::Order.new_ask(pair, 8.0, 300_000.0),
      Trader::Order.new_ask(pair, 1.0, 300_000.0)
    ]
  }

  let(:bad_order_type) {
    [
      Trader::Order.new_bid(pair, 8.0, 300_000.0),
      Trader::Order.new_ask(pair, 1.0, 300_000.0)
    ]
  }

  describe "sync" do

    it "should register new orders in backend and use the backend balance as limit" do
      pool.sync(first_wave)

      expect(backend.asks.count).to eq(2)
      expect(backend.asks.last[:pend_volume]).to eq(0.5)
    end

    it "should fail for orders that do not match the pool type" do
      expect { pool.sync(bad_order_type) }.to raise_error ArgumentError
    end
  end

  context "after some orders have been added" do

    before { pool.sync first_wave }

    describe "sync" do
      it "should try to reuse the existing orders" do
        pool.sync second_wave
        expect(backend.open_asks.count).to eq(1)
        expect(backend.open_asks.first[:pend_volume]).to eq(9.5)
      end
    end

    context "and some executed" do

      before { backend.simulate_buy(301_000, 7.5) }

      describe "sync" do
        it "should try to reuse the existing orders" do
          pool.sync second_wave
          expect(backend.open_asks.count).to eq(2)
          expect(backend.open_asks[0][:pend_volume]).to eq(2.0) # there are only 2.5 btc left
          expect(backend.open_asks[1][:pend_volume]).to eq(0.5)
        end
      end
    end
  end
end
