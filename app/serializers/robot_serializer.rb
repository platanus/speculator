class RobotSerializer < ActiveModel::Serializer
  attributes :id, :name, :started_at, :closed_at, :next_execution_at
end
