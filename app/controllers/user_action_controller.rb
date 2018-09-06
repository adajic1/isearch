class UserActionController < ApplicationController
  
  before_action :validate_params, only: [:create]
  def create
    if (!@params_valid) 
      send_data "ERROR: Invalid parameters"
    else 
      Session.get_or_create(request.remote_ip).user_actions.create(action_params)   
      send_data "OK"
    end
  end
  
  private
  
  # Validating action's parameters
  def validate_params   
    @params_valid = true
    @params_valid = false if !params[:action_type].present? || 
                             !params[:description].present?
  end
  
  def action_params
    params.permit(:action_type, :description)
  end
  
end
