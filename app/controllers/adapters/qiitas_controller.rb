# encoding: utf-8
class Adapters::QiitasController < Adapters::BaseController
  def create
    redirect_to settings_path
  end
end
