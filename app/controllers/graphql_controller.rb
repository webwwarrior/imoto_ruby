class GraphqlController < ApplicationController
  rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found

  include Devise::Controllers::SignInOut
  before_action :set_current_user

  protect_from_forgery except: [:query]

  # rubocop:disable all
  def query
    initialized_schema = GraphQL::Schema.define do
      query QueryRoot
      mutation MutationType
    end
    result_hash = initialized_schema.execute(
      params[:query],
      context: {
        attachments: params[:attachments],
        current_user: @user,
        helpers: {
          sign_in:  method(:sign_in),
          sign_out: method(:sign_out)
        }
      },
      variables: ensure_hash(params[:variables])
    )
    render json: result_hash
  end
  # rubocop:enable all

  def set_current_user
    customer_id = cookies.signed['customer.id']
    photographer_id = cookies.signed['photographer.id']
    @user = customer_id && Customer.find_by(id: customer_id) ||
            photographer_id && Photographer.find_by(id: photographer_id)
  end

  private

  def record_not_found(exception)
    render json: { error: exception.message }.to_json, status: 404
  end

  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end
end
