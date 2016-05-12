require 'rails_helper'

RSpec.describe RobotContext, type: :model do
  subject { build(:robot_context, config: 'foo: bar') }

  describe "associations" do
    # none
  end

  describe "validations" do
    it { is_expected.not_to allow_value('--foo').for(:config) }
    it { is_expected.to allow_value('foo: bar').for(:config) }
    it { is_expected.to allow_value(nil).for(:config) }
  end

  describe "default_context" do
    it "creates an initial robot context if no context exists" do
      expect { described_class.default_context }.to change { described_class.count }.by(1)
      expect { described_class.default_context }.not_to change { described_class.count }
    end
  end

  describe "decoded_config" do
    it "provides the decoded config hash" do
      expect(subject.decoded_config).to eq({ 'foo' => 'bar' })
    end
  end
end
