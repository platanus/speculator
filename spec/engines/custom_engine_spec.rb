require 'rails_helper'

describe CustomEngine do
  def robot(_config = nil)
    create(:robot, config: _config, delay: 20)
  end

  def engine_for(_robot)
    described_class.new _robot
  end

  let(:simple_robot) { robot }

  pending "valid_configuration?"

  describe "delay" do
    it { expect(engine_for(simple_robot).delay).to eq simple_robot.delay }
  end

  describe "tick" do
    it "should execute the given engine code using the provided DSL" do
      engine = engine_for robot "get_account('foo'); stat('bar'); alert('baz')"

      expect(engine).to receive(:get_account).with('foo').and_return(nil)
      expect(engine).to receive(:stat).with('bar').and_return(nil)
      expect(engine).to receive(:alert).with('baz').and_return(nil)
      engine.tick
    end

    it "should have access to extensions" do
      engine = engine_for robot "clp(1.9); usd(2)"

      expect(engine).to receive(:clp).with(1.9).and_return(nil)
      expect(engine).to receive(:usd).with(2).and_return(nil)
      engine.tick
    end
  end
end
