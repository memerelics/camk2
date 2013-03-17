# encoding: utf-8
class Adapters::LivedoorsController < Adapters::BaseController
  def create
    Adapters::Livedoor.create!({
      service_id: params[:id],
      api_key: params[:api_key]
    }.reverse_merge(default_params))

    redirect_to settings_path
  end
end
