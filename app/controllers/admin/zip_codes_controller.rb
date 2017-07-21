class Admin::ZipCodesController < Admin::BaseController
  def index
    zip_codes = ZipCode.search(params[:query]).limit(5).select('id, value as text')
    render json: zip_codes
  end
end
