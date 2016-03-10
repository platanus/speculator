require 'rails_helper'

RSpec.describe SyncOrder do

  let(:config) { { base: 'BTC', quote: 'CLP', base_balance: 10.0, quote_balance: 10000000.0 } } # used by fake backend as configuration
  let(:trader_account) { Trader.account(:fake, config).using(:BTC, :CLP) }
  let(:trader_backend) { trader_account.backend }
  let(:trader_order) { trader_account.ask(1.0, 300_000) }

  subject { described_class.new build(:order) }

  context "when order is new" do
    describe "bind!" do
      it { expect { subject.bind!(trader_order) }.to change { Order.count }.by(1) }

      it "should update local order" do
        subject.bind! trader_order

        expect(subject.order.instruction).to eq :ask
        expect(subject.order.volume).to eq 1.0
        expect(subject.order.pending_volume).to eq 1.0
        expect(subject.order.price).to eq 300_000
      end
    end
  end

  context "when order is already bound" do

    before { subject.bind!(trader_order) }

    context "and AR object is new instance" do

      let(:fresh_ref) { described_class.new Order.find subject.order.id }

      describe "refresh!" do
        it { expect { fresh_ref.refresh! }.not_to raise_error }
      end
    end

    describe "cancel!" do
      before { subject.cancel! }
      it { expect(subject.order.pending_volume).to eq 1.0 }
      it { expect(subject.order.unsynced_volume).to eq 0.0}
      it { expect(subject.order.open?).to be_falsy }
      it { expect(trader_backend.asks.first[:status]).to eq(Trader::AccountOrder::CANCELED)}
    end

    context "and has been partially executed" do
      before { trader_backend.simulate_buy(310_000, 0.4) }

      describe "refresh!" do
        before { subject.refresh! }
        it { expect(subject.order.pending_volume).to eq 0.6 }
        it { expect(subject.order.unsynced_volume).to eq 0.4 }
        it { expect(subject.order.open?).to be_truthy }
      end
    end

    context "and has been executed completely" do
      before { trader_backend.simulate_buy(310_000, 1.0) }

      describe "refresh!" do
        before { subject.refresh! }
        it { expect(subject.order.pending_volume).to eq 0.0 }
        it { expect(subject.order.open?).to be_falsy }
      end
    end
  end
end
