class Robot < ActiveRecord::Base

  has_many :accounts, inverse_of: :robot

  validates :name, :engine, presence: true
  validates :config, yaml_hash: true, allow_nil: true
  validate :engine_exists?

  def parsed_config
    return nil if config.nil?
    YAML.load config
  end

  def engine_class
    return nil if engine.nil?
    EngineResolver.new(engine).resolve
  end

  private

  def engine_exists?
    errors.add :engine, "invalid engine #{engine}" if engine_class.nil?
  end
end

# == Schema Information
#
# Table name: robots
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  engine            :string(255)
#  config            :text(65535)
#  last_execution_at :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
