ActiveAdmin.register RobotAlert do
  belongs_to :robot

  controller do
    defaults :collection_name => :alerts
  end
end
