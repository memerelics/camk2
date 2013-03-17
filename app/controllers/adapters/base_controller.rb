# encoding: utf-8
class Adapters::BaseController < ApplicationController
  before_filter :authenticate_user!

  private
  def default_params
    { user_id: current_user.id }
  end
end
