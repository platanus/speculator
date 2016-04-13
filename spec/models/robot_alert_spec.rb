require 'rails_helper'

RSpec.describe RobotAlert, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:robot) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:robot) }
  end
end
