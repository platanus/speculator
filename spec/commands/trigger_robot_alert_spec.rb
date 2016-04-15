require 'rails_helper'

describe TriggerRobotAlert do
  let!(:now) { Time.current.change(usec: 0) }
  let(:robot) { create(:robot) }

  before { allow_any_instance_of(described_class).to receive(:current_time).and_return now }

  def perform(_title, _message)
    described_class.new(robot: robot, title: _title, message: _message).perform
  end

  def create_alert(_title, _at)
    create(:robot_alert, robot: robot, title: _title, triggered_at: _at, last_triggered_at: _at)
  end

  def last_alert(_prop)
    robot.alerts.last.try(_prop)
  end

  it { expect { perform('foo', 'bar') }.to change { robot.alerts.count }.by(1) }
  it { expect { perform('foo', 'bar') }.to change { last_alert(:title) }.to('foo') }
  it { expect { perform('foo', 'bar') }.to change { last_alert(:triggered_at) }.to be_a Time }
  it { expect { perform('foo', 'bar') }.to change { last_alert(:last_triggered_at) }.to be_a Time }
  it { expect { perform('foo', 'bar') }.to change { last_alert(:message) }.to('bar') }
  it { expect { perform('foo', nil) }.to change { last_alert(:message) }.to('foo') }

  context 'when alert with different title already exist' do
    before { create_alert('wow ', nil) }

    it { expect { perform('foo', 'bar') }.to change { robot.alerts.count }.by(1) }
  end

  context 'when an alert triggered 1 hour ago with same title already exist' do
    before { create_alert('foo', now - 1.hour) }

    it { expect { perform('foo', 'bar') }.not_to change { robot.alerts.count } }
    it { expect { perform('foo', 'bar') }.not_to change { last_alert(:triggered_at) } }
    it { expect { perform('foo', 'bar') }.to change { last_alert(:last_triggered_at) }.by(1.hour) }
    it { expect { perform('foo', 'bar') }.to change { last_alert(:message) }.to 'bar' }
  end

  context 'when non-triggered alert with same title already exist' do
    before { create_alert('foo', nil) }

    it { expect { perform('foo', 'bar') }.to change { last_alert(:triggered_at) }.to now }
  end
end
