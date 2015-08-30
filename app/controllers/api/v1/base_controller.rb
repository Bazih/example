class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  protect_from_forgery with: :null_session
  respond_to :json

  protected

  # Find the user that owns the access token
  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    @current_ability ||= Ability.new(current_resource_owner)
  end
end