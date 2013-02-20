# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  devise :omniauthable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :uid, :token, :token_secret, :notebook_name

  has_many :notes
  has_many :adapters

  def self.create_or_update_by_evernote_oauth(auth, signed_in_resource=nil)
    user = User.where(uid: auth.uid).first
    if user.blank?
      user = User.create(uid: auth.uid,
                         token: auth.credentials.token,
                         token_secret: auth.credentials.secret)
    else
      user.update_attributes!(token: auth.credentials.token,
                              token_secret: auth.credentials.secret)
    end
    user
  end
end
