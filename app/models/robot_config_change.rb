class RobotConfigChange < ActiveRecord::Base
  belongs_to :robot
end

# == Schema Information
#
# Table name: robot_config_changes
#
#  id         :integer          not null, primary key
#  robot_id   :integer
#  config     :text(65535)
#  created_at :datetime
#
# Indexes
#
#  index_robot_config_changes_on_robot_id  (robot_id)
#
# Foreign Keys
#
#  fk_rails_08c1615a4e  (robot_id => robots.id)
#
