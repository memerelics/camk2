# coding: utf-8
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def evernote
    @user = User.find_or_create_by_evernote_oauth(request.env['omniauth.auth'], current_user)
    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, :kind => "EverNote") if is_navigational_format?
    else
      redirect_to root_path
    end
  end
end
