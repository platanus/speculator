class EngineResolver

  attr_reader :name

  def initialize(_name)
    @name = _name.to_sym
  end

  def resolve
    case name
    when :dummy
      DummyEngine
    when :ask_replicator
      AskReplicatorEngine
    else
      nil
    end
  end
end
