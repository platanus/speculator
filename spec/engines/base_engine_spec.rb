require 'rails_helper'

describe BaseEngine do
  let(:config) { "foo config" }
  let(:robot) { create(:robot, config: config) }
  let!(:accounts) { 3.times.map { |i| create(:account, robot: robot, name: "account-#{i}") } }

  let(:engine) { Class.new(BaseEngine).new robot }

  let(:exc_wo_backtrace) { ArgumentError.new 'foo' }
  let(:exc_w_backtrace) do
    exc = ArgumentError.new 'foo'
    exc.set_backtrace ['foo', 'bar']
    exc
  end

  before do
    allow(engine).to receive(:perform_with_configuration).and_return(nil)
  end

  describe "valid_configuration?" do
    it "calls validate_configuration" do
      expect(engine).to receive(:validate_configuration).with(config)
      engine.valid_configuration?
    end

    it { expect(engine.valid_configuration?).to be true }

    context "if validate_configuration returns false" do
      before { allow(engine).to receive(:validate_configuration).and_return(false) }

      it { expect(engine.valid_configuration?).to be false }
    end
  end

  describe "get_account" do
    it { expect { engine.get_account.name }.to raise_error ArgumentError }
    it { expect(engine.get_account('account-1').name).to eq 'account-1' }
    it { expect(engine.get_account('account-1')).to be_a SyncAccount }
  end

  describe "get_accounts" do
    it { expect(engine.get_accounts.count).to eq 3 }
    it { expect(engine.get_accounts('account-2').count).to eq 1 }
  end

  describe "logger" do
    it { expect { engine.logger.log('hello') }.to change { robot.logs.count }.by(1) }
  end

  describe "alert" do
    it { expect { engine.alert(:foo) }.to change { robot.logs.count }.by(1) }
    it { expect { engine.alert(:foo) }.to change { robot.alerts.count }.by(1) }
  end

  describe "log_exception" do
    it { expect { engine.log_exception(exc_wo_backtrace) }.to change { robot.logs.count }.by(1) }
    it { expect { engine.log_exception(exc_w_backtrace) }.to change { robot.logs.count }.by(3) }
  end

  describe "tick" do
    # TODO: test that perform is ran in an isolated context
    it do
      expect(engine).to receive(:perform_with_configuration)
      engine.tick
    end
  end

  describe "stat" do
    it { expect { engine.stat(:balance, 1.0) }.to change { RobotStat.count }.by(1) }
    it { expect { engine.stat(:balance) { 1.0 } }.to change { RobotStat.count }.by(1) }
    it { expect { engine.stat(:balance, every: 1.minute) { 1.0 } }.to change { RobotStat.count }.by(1) }

    context "when some stats have already been recorded" do
      before do
        create(:robot_stat, robot: robot, name: 'balance', created_at: Time.current - 20.minutes)
      end

      it { expect { engine.stat(:balance, every: 1.hour) { 1.0 } }.not_to change { RobotStat.count } }
    end
  end

  describe "tick with errors" do
    before do
      allow(engine).to receive(:perform_with_configuration).and_raise(ArgumentError, "foo")
    end

    it do
      expect { engine.tick }.to change { robot.logs.count }.by_at_least 2
      expect(robot.logs.first.level).to eq :error
      expect(robot.logs.first.message).to eq 'ArgumentError: foo'
    end
  end
end
