require 'rails_helper'

describe RobotStatService do
  let(:robot) { create(:robot) }
  let(:service) { described_class.new robot, :some_stat }
  let(:other_service) { described_class.new robot, :other_stat }

  let(:current_time) { Time.parse('20010101T003000+0000') }

  before do
    allow(service).to receive(:current_time).and_return current_time
    allow(other_service).to receive(:current_time).and_return current_time
  end

  describe "can_run_if_runs_at?" do
    it { expect(service.can_run_if_runs_at? '00:00').to be true }
    it { expect { service.can_run_if_runs_at? '0000' }.to raise_error ArgumentError }
  end

  describe "can_run_if_runs_every?" do
    it { expect(service.can_run_if_runs_every? 2.minutes).to be true }
    it { expect { service.can_run_if_runs_every? '0000' }.to raise_error ArgumentError }
  end

  describe "record" do
    it { expect { service.record(1.0) }.to change { RobotStat.count }.by(1) }
    it { expect(service.record(1.0).name).to eq 'some_stat' }
  end

  context "given a stat with same name has already been registered" do

    before do
      create(:robot_stat, robot: robot, name: :some_stat, created_at: current_time - 31.minutes)
      create(:robot_stat, robot: robot, name: :other_stat, created_at: current_time - 29.minutes)
    end

    describe "can_run_if_runs_at?" do
      it { expect(service.can_run_if_runs_at? '00:00').to be true }
      it { expect(other_service.can_run_if_runs_at? '00:00').to be false }
    end

    describe "can_run_if_runs_every?" do
      it { expect(service.can_run_if_runs_every? 30.minutes).to be true }
      it { expect(other_service.can_run_if_runs_every? 30.minutes).to be false }
    end
  end
end
