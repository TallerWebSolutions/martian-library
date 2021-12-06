# frozen_string_literal: true

class GraphqlController < ApplicationController
  protect_from_forgery with: :exception

  before_action :current_user

  def execute
    if @user.present?
      result = MartianLibrarySchema.execute(
        params[:query],
        variables: ensure_hash(params[:variables]),
        context: { current_user: @user },
        operation_name: params[:operationName]
      )
      render json: result
    else
      render json: { status: 404, message: 'Not Found', data: {} }, status: :not_found
    end
  end

  private

  # Handle form data, JSON body, or a blank value
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

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { error: { message: e.message, backtrace: e.backtrace }, data: {} }, status: :internal_server_error
  end
end
