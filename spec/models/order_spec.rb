require 'rails_helper'

RSpec.describe Order, type: :model do

  subject { create(:order) }

  describe "associations" do
    it { is_expected.to belong_to(:account) }
  end

  describe "validations" do
    # it { is_expected.to validate_presence_of(:instruction) }
    # it { is_expected.to allow_value('foo: bar').for(:credentials) }
    # it { is_expected.not_to allow_value(nil).for(:volume) }
    # it { is_expected.not_to allow_value(nil).for(:price) }
    # it { is_expected.not_to allow_value(nil).for(:instruction) }
  end
end
