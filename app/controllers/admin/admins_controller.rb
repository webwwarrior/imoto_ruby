class Admin::AdminsController < Admin::BaseController
  def update
    admin = Admin.find_by(email: params[:admin][:email])
    if admin.valid_password?(params[:admin][:current_password])
      super
    else
      render :edit, locals: { page: Administrate::Page::Form.new(dashboard, requested_resource) }
    end
  end

  private

  def resource_params
    params.require(resource_name).permit(:password, :password_confirmation, :first_name, :last_name,
                                         :email).select { |_key, value| value.present? }
  end
end
