class Robot < ActiveRecord::Base
  has_many :accounts, inverse_of: :robot
  has_many :logs, class_name: 'RobotLog', inverse_of: :robot
  has_many :stats, class_name: 'RobotStat', inverse_of: :robot
  has_many :alerts, class_name: 'RobotAlert', inverse_of: :robot
  has_many :config_changes, class_name: 'RobotConfigChange', inverse_of: :robot

  before_validation :reset_engine_configuration, if: :engine_changed?
  after_save :save_config_history, if: :config_changed?
  validates :name, :engine, :delay, presence: true
  validate :engine_exists
  validate :engine_accepts_configuration

  def self.due_execution
    self.where('next_execution_at < ?', Time.current)
  end

  def enable
    self.update_attributes!(next_execution_at: Time.current)
  end

  def disable
    self.update_attributes!(next_execution_at: nil)
  end

  def enabled?
    !next_execution_at.nil?
  end

  def context
    RobotContext.default_context
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

  def engine_config_lang
    if engine_class.respond_to? :config_lang
      engine_class.config_lang
    else
      'text'
    end
  end

  def load_engine
    engine_class.new self
  end

  private

  def save_config_history
    config_changes.create! config: config
  end

  def engine_exists
    errors.add :engine, "invalid engine #{engine}" if engine_class.nil?
  end

  def reset_engine_configuration
    if !engine_class.nil? && !load_engine.valid_configuration?
      self.config = load_engine.default_raw_configuration
    end
  end

  def engine_accepts_configuration
    if !engine_class.nil? && !load_engine.valid_configuration?
      errors.add :config, "invalid engine configuration"
    end
  end

  def engine_class
    return nil if engine.nil?
    EngineResolver.new(engine).resolve
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
#  context_config    :text(65535)
#
