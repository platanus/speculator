ActiveAdmin.register RobotContext do
  menu label: 'Context'

  actions :update, :edit, :update

  permit_params :config, :context_config

  controller do
    def index
      redirect_to edit_admin_robot_context_path RobotContext.default_context
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "Details" do
      input :config, as: :code, input_html: { mode: 'yaml' }
    end
    f.actions
  end
end
