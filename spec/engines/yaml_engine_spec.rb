require 'rails_helper'

describe YamlEngine do
  def new_engine(_robot)
    Class.new(described_class) do
      def perform_with_hash(_hash)
        nil
      end
    end.new(_robot)
  end

  let(:robot) { create(:robot, config: "foo: 'bar'", delay: 20) }
  let(:bad_robot) { create(:robot, config: "bad yaml") }
  let(:valid_engine) { new_engine(robot) }

  describe "valid_configuration?" do
    it { expect(valid_engine.valid_configuration?).to be true }
    it { expect(new_engine(bad_robot).valid_configuration?).to be false }
  end

  describe "perform_with_hash" do
    it "is called with the decoded config string as a hash" do
      expect(valid_engine)
        .to receive(:perform_with_hash)
        .with({ 'foo' => 'bar', 'delay' => 20 })
      valid_engine.tick
    end
  end
end
