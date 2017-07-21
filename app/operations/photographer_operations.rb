class PhotographerOperations < BaseOperations
  def self.create(params)
    password = SecureRandom.hex(8)
    resource = Photographer.new(params.merge(password: password))
    Photographer::SendPassword.perform_async(resource.id, password) if resource.save
    resource
  end

  def self.update(photographer, params)
    params[:photographer].delete(:password) if params[:photographer][:password].blank?
    params[:photographer].delete(:password_confirmation) if params[:photographer][:password].blank?
    params = prepare_for_delete(:photographer_attributes, photographer, photographer_params(params))
    photographer.update(params)
    photographer
  end

  def self.photographer_params(params)
    permittable = [
      :first_name, :last_name, :email, :zip_code, :start_work_at, :end_work_at, :default_time_zone, {
        zip_code_ids: [], photographer_attributes_attributes:
          [:id, :attribute_item_id, :default_time, :extra_time, :rate, :additional_rate, :default_time_zone]
      }
    ]

    photographer = params[:photographer]

    permittable.push :password, :password_confirmation if
      [photographer[:password], photographer[:password_confirmation]].any?(&:present?)

    params.require(:photographer).permit(*permittable)
  end
end
