require 'rails_helper'

describe CalculateVpin do
  let!(:account) { create(:account) }
  let(:ref) { Time.current }

  before do
    create(:transaction, timestamp: ref - 1, account: account, volume: 10.0, instruction: :bid)
    create(:transaction, timestamp: ref - 2, account: account, volume: 30.0, instruction: :ask)
    create(:transaction, timestamp: ref - 3, account: account, volume: 40.0, instruction: :bid)
    create(:transaction, timestamp: ref - 4, account: account, volume: 60.0, instruction: :ask)
    create(:transaction, timestamp: ref - 5, account: account, volume: 20.0, instruction: :bid)
    create(:transaction, timestamp: ref - 6, account: account, volume: 30.0, instruction: :ask)
    create(:transaction, timestamp: ref - 7, account: account, volume: 45.0, instruction: :ask)
    create(:transaction, timestamp: ref - 8, account: account, volume: 65.0, instruction: :bid)
  end

  def perform(_block_size)
    described_class.for account: account, block_size: _block_size
  end

  it { expect(perform(10)).to eq 1.0 }
  it { expect(perform(20)).to eq 0.0 }
  it { expect(perform(40)).to eq -0.5 }
  it { expect(perform(300)).to eq -0.1 }
  it { expect(perform(1000)).to eq -0.1 }
end
