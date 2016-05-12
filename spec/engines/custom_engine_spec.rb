require 'rails_helper'

describe CustomEngine do
  def new_engine(_robot)
    described_class.new(_robot)
  end

  let(:robot) { create(:robot, config: "get_account('foo'); stat('bar'); alert('baz')", delay: 20) }
  let(:bad_robot) { create(:robot, config: "bad yaml") }
  let(:engine) { new_engine robot }

  pending "valid_configuration?"

  describe "tick" do
    it "should execute the given engine code using the provided DSL" do
      expect(engine).to receive(:get_account).with('foo').and_return(nil)
      expect(engine).to receive(:stat).with('bar').and_return(nil)
      expect(engine).to receive(:alert).with('baz').and_return(nil)
      engine.tick
    end
  end
end
