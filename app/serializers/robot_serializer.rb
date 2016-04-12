class RobotSerializer < ActiveModel::Serializer
  attributes :id, :name, :started_at, :last_execution_at, :next_execution_at
end
