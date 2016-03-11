module ActiveAdmin
  module ExtensionsHelper

    def yaml_viewer(_yaml)
      return "<pre>#{_yaml}</pre>".html_safe
    end

    def robot_pulse_viewer(_robot)
      return "<div robot-pulse-viewer robot-id=\"#{_robot.id}\"></div>".html_safe
    end

    def robot_log_viewer(_robot)
      return "<div robot-log-viewer robot-id=\"#{_robot.id}\"></div>".html_safe
    end

  end
end
