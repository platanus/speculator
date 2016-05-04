require 'rails_helper'

describe RobotContextService do
  let(:config) do
    { 'conversions' => [{ 'from' => 'USD', 'to' => 'CLP', 'rate' => 700.0 }] }
  end

  let(:robot) { create(:robot, context_config: config ) }
  let(:service) { described_class.new robot }

  describe "apply" do
    it "should execute block with using the given currency conversions" do
      service.apply do
        expect(Trader::Currency.for_code(:USD).convertible_to? :CLP).to be_truthy
      end
      expect(Trader::Currency.for_code(:USD).convertible_to? :CLP).to be_falsy
    end
  end
end
