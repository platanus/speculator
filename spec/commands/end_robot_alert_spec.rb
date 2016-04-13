require 'rails_helper'

describe EndRobotAlert do
  let(:robot) { create(:robot) }

  def perform(_title)
    described_class.new(robot: robot, title: _title).perform
  end

  def create_alert(_title, _at)
    create(:robot_alert, robot: robot, title: _title, triggered_at: _at, last_triggered_at: _at)
  end

  context 'when no alert with same title exists' do
    before { create_alert('wow', Time.current) }

    it { expect(perform('foo')).to be false }
    it { expect { perform('foo') }.not_to change { robot.alerts.live.count } }
  end

  context 'when alert with same title already exists' do
    before { create_alert('foo ', Time.current) }

    it { expect(perform('foo')).to be true }
    it { expect { perform('foo') }.to change { robot.alerts.live.count }.by(-1) }
  end
end
