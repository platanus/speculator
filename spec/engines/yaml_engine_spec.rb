require 'rails_helper'

describe YamlEngine do
  def new_engine(_robot)
    Class.new(described_class).new(_robot)
  end

  let(:robot) { create(:robot, config: "foo: 'bar'", delay: 20) }
  let(:bad_robot) { create(:robot, config: "bad yaml") }
  let(:valid_engine) { new_engine(robot) }

  before do
    allow(valid_engine).to receive(:perform).and_return nil
  end

  describe "valid_configuration?" do
    it { expect(valid_engine.valid_configuration?).to be true }
    it { expect(new_engine(bad_robot).valid_configuration?).to be false }
  end

  describe "tick" do
    it "should call perform and set the params property to the provided configuration" do
      valid_engine.tick
      expect(valid_engine.params).to eq({ 'foo' => 'bar', 'delay' => 20 })
      expect(valid_engine).to have_received(:perform)
    end
  end
end
