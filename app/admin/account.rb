ActiveAdmin.register Account do

  belongs_to :robot, parent_class: Robot

  permit_params :name, :exchange, :base_currency, :quote_currency, :new_credentials

  form :partial => "form"

  controller do
    def index
      redirect_to admin_robot_path(id: params[:robot_id])
    end

    def show
      redirect_to admin_robot_path(id: params[:robot_id])
    end
  end
end
