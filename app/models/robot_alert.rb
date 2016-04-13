class RobotAlert < ActiveRecord::Base
  belongs_to :robot

  validates :robot, :title, presence: true
end

# == Schema Information
#
# Table name: robot_alerts
#
#  id                :integer          not null, primary key
#  robot_id          :integer
#  title             :string(255)
#  message           :text(65535)
#  last_triggered_at :datetime
#  triggered_at      :datetime
#  created_at        :datetime
#
# Indexes
#
#  index_robot_alerts_on_robot_id  (robot_id)
#
# Foreign Keys
#
#  fk_rails_59f7c3256b  (robot_id => robots.id)
#
