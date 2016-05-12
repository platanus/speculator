require 'rails_helper'

RSpec.describe RobotConfigChange, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:robot) }
  end
end
