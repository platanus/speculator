require 'rails_helper'

RSpec.describe Robot, type: :model do

  subject { create(:robot) }

  describe "associations" do
    it { is_expected.to have_many(:accounts) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:engine) }
    it { is_expected.not_to allow_value('anything').for(:engine) }
    it { is_expected.to allow_value('foo: bar').for(:config) }
    it { is_expected.not_to allow_value('-- yaml').for(:config) }
    it { is_expected.not_to allow_value('* yaml').for(:config) }
  end
end
