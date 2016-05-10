class RobotContext < ActiveRecord::Base
  validates :config, yaml_hash: true, allow_nil: true

  def self.default_context
    default = first
    default = build_default_context if default.nil?
    default
  end

  def decoded_config
    return {} if config.nil?
    YAML.load config
  end

  def display_name
    "Default Context"
  end

  private

  def self.build_default_context
    create! config: YAML.dump({})
  end
end

# == Schema Information
#
# Table name: robot_contexts
#
#  id         :integer          not null, primary key
#  config     :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
