require 'rails_helper'

RSpec.describe RobotLog, type: :model do
  subject { create(:robot_log) }

  describe "associations" do
    it { is_expected.to belong_to(:robot) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:message) }
    it { is_expected.to validate_presence_of(:robot) }
  end
end
