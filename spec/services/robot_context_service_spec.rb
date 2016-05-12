require 'rails_helper'

describe RobotContextService do
  let(:config) do
    { 'conversions' => [{ 'from' => 'USD', 'to' => 'CLP', 'rate' => 700.0 }] }
  end

  def service(_config)
    robot = OpenStruct.new(context: create(:robot_context, config: YAML.dump(_config)))
    described_class.new robot
  end

  describe "apply" do
    it "should execute block with using the given currency conversions" do
      service(config).apply do
        expect(Trader::Currency.for_code(:USD).convertible_to? :CLP).to be_truthy
      end
      expect(Trader::Currency.for_code(:USD).convertible_to? :CLP).to be_falsy
    end
  end
end
