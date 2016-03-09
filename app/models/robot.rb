class Robot < ActiveRecord::Base

  has_many :accounts, inverse_of: :robot

  validates :name, :engine, :delay, presence: true
  validates :config, yaml_hash: true, allow_nil: true
  validate :engine_exists?

  def self.due_execution
    self.where('next_execution_at < ?', Time.current)
  end

  def enable
    self.update_attributes!(next_execution_at: Time.current)
  end

  def disable
    self.update_attributes!(next_execution_at: nil)
  end

  def try_set_started
    with_lock do
      return false unless started_at.nil?
      self.update_attributes!(started_at: Time.current, next_execution_at: Time.current + delay)
    end
    true
  end

  def try_set_finished(_error=nil)
    with_lock do
      return false if started_at.nil?
      self.update_attributes!(started_at: nil, last_execution_at: Time.current)
    end
    true
  end

  def parsed_config
    return {} if config.nil?
    YAML.load config
  end

  def engine_class
    return nil if engine.nil?
    EngineResolver.new(engine).resolve
  end

  def load_engine
    engine_class.new accounts.to_a, parsed_config.merge(fixed_config)
  end

  private

  def fixed_config
    { 'delay' => delay }
  end

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
#  delay             :float(24)
#  started_at        :datetime
#  next_execution_at :datetime
#
