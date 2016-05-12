require 'rails_helper'

RSpec.describe Robot, type: :model do

  subject { create(:robot, delay: 5.0) }

  describe "associations" do
    it { is_expected.to have_many(:accounts) }
    it { is_expected.to have_many(:logs) }
    it { is_expected.to have_many(:stats) }
    it { is_expected.to have_many(:alerts) }
    it { is_expected.to have_many(:config_changes) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:engine) }
    it { is_expected.to validate_presence_of(:delay) }
    it { is_expected.not_to allow_value('anything').for(:engine) }
    it { is_expected.to allow_value('foo: bar').for(:config) }
    it { is_expected.to allow_value(nil).for(:config) }

    context "selected engine considers config invalid" do
      before do
        allow_any_instance_of(DummyEngine)
          .to receive(:validate_configuration) { |_, x| x != 'foo' }
      end

      it { is_expected.not_to allow_value('foo').for(:config) }
    end
  end

  describe "config" do
    it "generates a new config change every time it changes" do
      expect { subject.update_attributes(config: 'new: config') }
        .to change { RobotConfigChange.count }.by(1)
    end

    context "on engine change, if config invalid under new engine" do
      before do
        subject

        allow_any_instance_of(DummyEngine)
          .to receive(:validate_configuration) { |_, x| x == 'bar' }

        allow_any_instance_of(DummyEngine)
          .to receive(:generate_default_configuration).and_return 'bar'
      end

      it "switches to engine default config" do
        expect { subject.engine_will_change!; subject.save! }
          .to change { subject.reload.config }
      end
    end

    context "on engine change, if config valid under new engine" do
      it "does not change config" do
        expect { subject.engine_will_change!; subject.save! }
          .not_to change { subject.reload.config }
      end
    end
  end

  describe "enable" do
    it { expect { subject.enable }.to change { subject.next_execution_at }.to be_a Time }
  end

  context "when robot is enabled" do

    before { subject.enable }

    describe "disable" do
      it { expect { subject.disable }.to change { subject.next_execution_at }.to nil }
    end
  end

  describe "try_set_started" do
    it { expect(subject.try_set_started).to be_truthy }
    it { expect { subject.try_set_started }.to change { subject.next_execution_at }.to be > Time.current }
    it { expect { subject.try_set_started }.to change { subject.started_at }.to be_a Time }

    it "should not allow concurrent executions" do
      threads = []
      succeded = 0
      threads << Thread.new { succeded += 1 if subject.try_set_started }
      threads << Thread.new { succeded += 1 if subject.try_set_started }
      threads << Thread.new { succeded += 1 if subject.try_set_started }
      threads << Thread.new { succeded += 1 if subject.try_set_started }
      threads.each &:join

      expect(succeded).to eq 1
    end
  end

  describe "try_set_finished" do
    it { expect(subject.try_set_finished).to be_falsy }
  end

  context "when robot has been started" do

    before { subject.try_set_started }

    describe "try_set_started" do
      it { expect(subject.try_set_started).to be_falsy }
    end

    describe "try_set_finished" do
      it { expect { subject.try_set_finished }.to change { subject.started_at }.to be nil }
    end
  end
end
