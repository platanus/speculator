require 'rails_helper'

RSpec.describe RobotStat, type: :model do
  subject { create(:robot_stat) }

  describe "associations" do
    it { is_expected.to belong_to(:robot) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:value) }
  end
end
