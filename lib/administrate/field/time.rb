require 'administrate/field/base'
require 'rails'

module Administrate
  module Field
    class Time < Administrate::Field::Base
      class Engine < ::Rails::Engine
      end
    end
  end
end
