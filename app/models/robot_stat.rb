class RobotStat < ActiveRecord::Base
  belongs_to :robot

  validates :robot, :name, :value, presence: true
end

# == Schema Information
#
# Table name: robot_stats
#
#  id         :integer          not null, primary key
#  robot_id   :integer
#  name       :string(255)
#  value      :float(24)
#  created_at :datetime         not null
#
# Indexes
#
#  index_robot_stats_on_robot_id  (robot_id)
#
# Foreign Keys
#
#  fk_rails_1652484447  (robot_id => robots.id)
#
