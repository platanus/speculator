require 'rails_helper'

describe OrderPool do

  let(:credentials) { "base: BTC\nquote: CLP\nbase_balance: 10.0\nquote_balance: 100000000.0" } # used by fake backend as configuration
  let(:raw_account) { create(:account, exchange: 'fake', base_currency: 'BTC', quote_currency: "CLP", credentials: credentials) }
  let(:account) { SyncAccount.new raw_account }
  let(:backend) { account.core_account.backend }

  let(:pair) { Trader::CurrencyPair.new btc, clp }
  let(:ask_pool) { described_class.new account, :ask, price_thr: clp(4), min_volume: btc(0.1) }
  let(:bid_pool) { described_class.new account, :bid, price_thr: clp(5), min_volume: btc(0.001) }

  let(:first_ask_wave) {
    [
      Trader::Order.new_ask(pair, 9.5, 300_000.0),
      Trader::Order.new_ask(pair, 1.0, 305_000.0)
    ]
  }

  let(:second_ask_wave) {
    [
      Trader::Order.new_ask(pair, 9.0, 300_000.0),
      Trader::Order.new_ask(pair, 0.4, 300_000.0)
    ]
  }

  let(:first_bid_wave) {
    [
      Trader::Order.new_bid(pair, 0.07, 467_933),
      Trader::Order.new_bid(pair, 0.49, 465_325),
      Trader::Order.new_bid(pair, 2.28, 468_106),
      Trader::Order.new_bid(pair, 1.10, 469_300),
      Trader::Order.new_bid(pair, 0.01, 468_619),
      Trader::Order.new_bid(pair, 0.04, 461_453),
      Trader::Order.new_bid(pair, 0.92, 464_664),
      Trader::Order.new_bid(pair, 0.10, 465_040),
      Trader::Order.new_bid(pair, 0.48, 464_901),
      Trader::Order.new_bid(pair, 1.48, 461_494),
      Trader::Order.new_bid(pair, 2.00, 461_696),
      Trader::Order.new_bid(pair, 2.16, 462_321),
      Trader::Order.new_bid(pair, 0.46, 461_313),
      Trader::Order.new_bid(pair, 1.68, 448_835),
      Trader::Order.new_bid(pair, 2.41, 457_897)
    ]
  }

  let(:second_bid_wave) {
    [
      Trader::Order.new_bid(pair, 1.45, 476_669),
      Trader::Order.new_bid(pair, 1.82, 475_920),
      Trader::Order.new_bid(pair, 1.69, 475_212),
      Trader::Order.new_bid(pair, 2.19, 474_290),
      Trader::Order.new_bid(pair, 2.28, 473_466),
      Trader::Order.new_bid(pair, 1.90, 472_700),
      Trader::Order.new_bid(pair, 1.71, 472_154),
      Trader::Order.new_bid(pair, 2.32, 471_215),
      Trader::Order.new_bid(pair, 2.14, 470_343),
      Trader::Order.new_bid(pair, 2.18, 469_463),
      Trader::Order.new_bid(pair, 1.90, 468_648),
      Trader::Order.new_bid(pair, 2.10, 467_802)
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
      ask_pool.sync(first_ask_wave)

      expect(backend.open_asks.count).to eq(2)
      expect(backend.open_asks.last[:pend_volume]).to eq(0.5)
    end

    it "should register new orders in backend and use the backend balance as limit" do
      bid_pool.sync(first_bid_wave)

      expect(backend.bids.count).to eq(15)
      expect(backend.bids.last[:pend_volume]).to eq(2.41)
    end

    it "should fail for orders that do not match the pool type" do
      expect { ask_pool.sync(bad_order_type) }.to raise_error ArgumentError
    end
  end

  context "after some bids have been added" do
    before { bid_pool.sync first_bid_wave }

    describe "sync" do
      it "should properly change the slope tip" do
        bid_pool.sync second_bid_wave
        expect(backend.open_bids.count).to eq(12)
        expect(backend.open_bids.first[:pend_volume]).to eq(1.45)
      end
    end
  end

  context "after some asks have been added" do

    before { ask_pool.sync first_ask_wave }

    describe "sync" do
      it "should try to reuse the existing orders" do
        ask_pool.sync second_ask_wave
        expect(backend.open_asks.count).to eq(1)
        expect(backend.open_asks.first[:pend_volume]).to eq(9.5)
      end
    end

    context "and some executed" do

      before { backend.simulate_buy(301_000, 7.5) }

      describe "sync" do
        it "should try to reuse the existing orders" do
          ask_pool.sync second_ask_wave
          expect(backend.open_asks.count).to eq(2)
          expect(backend.open_asks[0][:pend_volume]).to eq(2.0) # there are only 2.5 btc left
          expect(backend.open_asks[1][:pend_volume]).to eq(0.5)
        end
      end
    end
  end
end
