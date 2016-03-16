ActiveAdmin.register Account do
  menu false

  permit_params :robot_id, :name, :exchange, :base_currency, :quote_currency, :credentials

  form :partial => "form"

  index do
    column :name
    column :exchange
    actions defaults: true
  end

  show do
    attributes_table do
      row :name
      row :exchange
      row :market do
        "#{account.base_currency}/#{account.quote_currency}"
      end

      row :created_at
      row :updated_at
      row :credentials_set do
        account.encrypted_credentials.nil? ? 'No' : 'Yes'
      end
    end
  end

  controller do
    def create
      create! do |format|
        format.html { redirect_to admin_robot_path(resource.robot) }
      end
    end

    def update
      update! do |format|
        format.html { redirect_to admin_robot_path(resource.robot) }
      end
    end

    def destroy
      destroy! do |format|
        format.html { redirect_to admin_robot_path(resource.robot) }
      end
    end
  end
end
