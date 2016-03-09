require 'rails_helper'

describe RobotDispatcherService do

  let(:service) { described_class.new sleep: 0.1 }

  before do
    allow(service).to receive(:tick).and_return(nil)
  end

  pending "add some examples"

end
