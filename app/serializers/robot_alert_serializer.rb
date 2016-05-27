class RobotAlertSerializer < ActiveModel::Serializer
  attributes :id, :title, :message, :last_triggered_at, :triggered_at

  def created_at
    object.created_at.to_i
  end
end
