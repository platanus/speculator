class RobotStatSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :name, :value

  def created_at
    object.created_at.to_i
  end
end
