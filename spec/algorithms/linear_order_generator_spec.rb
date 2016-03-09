require 'rails_helper'

describe LinearOrderGenerator do

  let(:gen) { described_class.new :bid, 100.0, 20.0 }

  describe "generate" do

    it { expect(gen.generate(200.0, 1000.0).length).to eq 5 }
    it { expect(gen.generate(200.0, 1000.0)[1][1]).to eq 180.0 }
    it { expect(gen.generate(200.0, 1000.0).map { |p| p[0] }.inject(0.0, &:+)).to eq 1000.0 }

  end

end
