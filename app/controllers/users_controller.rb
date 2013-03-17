# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:welcome]

  def welcome
  end
  def settings
    @adapters = current_user.adapters
  end

  def update_settings
    current_user.update_attributes!(notebook_name: params[:notebook_name])
    flash[:success] = I18n.t 'updated'
    render :settings
  end
end
