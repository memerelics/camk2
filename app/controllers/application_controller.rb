# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  def evernote
    return nil unless signed_in?
    @evernote ||= EvernoteApi.new(current_user) #TODO: production mode.
  end
  helper_method :evernote
end
