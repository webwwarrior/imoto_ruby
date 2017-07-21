class Admin::BaseController < Administrate::ApplicationController
  before_action :authenticate_admin!
end
