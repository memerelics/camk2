# encoding: utf-8
class Adapters::HatenaDiariesController < Adapters::BaseController
  def create
    redirect_to settings_path
  end
end
