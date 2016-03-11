ActiveAdmin.register RobotLog do
  belongs_to :robot

  controller do
    defaults :collection_name => :logs
  end
end
