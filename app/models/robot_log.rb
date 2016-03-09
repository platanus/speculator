class RobotLog < ActiveRecord::Base
  belongs_to :robot

  validates :message, :robot, presence: true
end

# == Schema Information
#
# Table name: robot_logs
#
#  id         :integer          not null, primary key
#  robot_id   :integer
#  created_at :datetime
#  message    :text(65535)
#
# Indexes
#
#  index_robot_logs_on_robot_id  (robot_id)
#
# Foreign Keys
#
#  fk_rails_93048e31bf  (robot_id => robots.id)
#
