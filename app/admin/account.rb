ActiveAdmin.register Account do
  menu false

  permit_params :robot_id, :name, :exchange, :base_currency, :quote_currency, :new_credentials

  form :partial => "form"

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
