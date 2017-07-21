class Admin::PhotographersController < Admin::BaseController
  before_action :set_time_zones, only: [:new, :edit, :create, :update]

  def create
    photographer = PhotographerOperations.create(resource_params)
    respond_for(photographer, :new)
  end

  def update
    photographer = PhotographerOperations.update(requested_resource, params)
    respond_for(photographer, :edit)
  end

  private

  def respond_for(resource, action)
    if resource.valid?
      redirect_to([namespace, resource], notice: translate_with_resource('update.success'))
    else
      render action, locals: { page: Administrate::Page::Form.new(dashboard, resource) }
    end
  end

  def resource_params
    params.require(resource_name).permit(:first_name, :last_name, :email, :start_work_at, :end_work_at,
                                         :password, :password_confirmation,
                                         :default_time_zone, zip_code_ids: [])
  end

  def set_time_zones
    @time_zones = ZipCode.pluck('DISTINCT time_zone')
  end
end
