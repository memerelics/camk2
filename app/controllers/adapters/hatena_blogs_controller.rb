# encoding: utf-8
class Adapters::HatenaBlogsController < Adapters::BaseController
  def create
    redirect_to settings_path
  end
end
