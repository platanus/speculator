require 'rails_helper'

describe BaseEngine do

  let(:accounts) { 3.times.map { |i| create(:account, name: "account-#{i}") } }
  let(:config) { { foo: 'bar' } }

  let(:engine) { Class.new(BaseEngine).new accounts, config }

  before do
    allow(engine).to receive(:unpack_config).and_return(nil)
    allow(engine).to receive(:perform).and_return(nil)
  end

  describe "get_account" do
    it { expect { engine.get_account.name }.to raise_error ArgumentError }
    it { expect(engine.get_account('account-1').name).to eq 'account-1' }
    it { expect(engine.get_account('account-1')).to be_a SyncAccount }
  end

  describe "get_accounts" do
    it { expect(engine.get_accounts.count).to eq 3 }
    it { expect(engine.get_accounts('account-2').count).to eq 1 }
  end

  describe "tick" do
    # TODO: test that perform is ran in an isolated context
    it do
      expect(engine).to receive(:unpack_config)
      expect(engine).to receive(:perform)
      engine.tick
    end
  end
end
