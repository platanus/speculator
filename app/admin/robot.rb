ActiveAdmin.register Robot do

  permit_params :name, :engine, :delay, :config

  filter :name
  filter :engine,  as: :check_boxes, collection: [ 'dummy', 'ask_replicator' ]

  index do
    column :name
    column :engine
    column :delay
    column :last_execution_at
    actions defaults: true
  end

  form do |f|
    f.semantic_errors
    f.inputs "Details" do
      input :name
      input :engine, as: :select, collection: [ 'dummy', 'ask_replicator' ]
      input :delay
      input :config, as: :text
    end
    f.actions
  end

  show do
    columns do
      column do
        attributes_table do
          row :name
          row :engine
          row :created_at
          row :updated_at
          row :delay
          row :config do
            yaml_viewer robot.config
          end
        end
      end

      column do
        panel "Status" do
          robot_pulse_viewer(robot) +
          robot_log_viewer(robot)
        end
      end
    end

    panel "Accounts" do
      table_for(robot.accounts, :sortable => true, :class => 'index_table') do
        column :name
        column :exchange
        column :base_currency
        column :quote_currency
        column do |account|
          link_to('Edit', edit_admin_account_path(account)) +
          link_to("Delete", admin_account_path(account), :method => :delete, :data => {:confirm => "Are you sure?"})
        end
      end
    end

    active_admin_comments
  end

  member_action :enable, method: :post do
    resource.enable
    redirect_to resource_path, notice: "Robot enabled!"
  end

  member_action :disable, method: :post do
    resource.disable
    redirect_to resource_path, notice: "Robot disabled!"
  end

  action_item :add_account, only: :show do
    link_to('Add Account', new_admin_account_path(account_robot_id: robot.id))
  end

  action_item :disable, only: :show, if: proc { robot.enabled? } do
    link_to('Disable', disable_admin_robot_path(robot), method: :post)
  end

  action_item :force, only: :show, if: proc { robot.enabled? } do
    link_to('Force Run', enable_admin_robot_path(robot), method: :post)
  end

  action_item :enable, only: :show, if: proc { !robot.enabled? } do
    link_to('Enable', enable_admin_robot_path(robot), method: :post)
  end
end
