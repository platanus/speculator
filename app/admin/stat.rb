ActiveAdmin.register RobotStat do
  belongs_to :robot

  controller do
    defaults :collection_name => :stats
  end
end
