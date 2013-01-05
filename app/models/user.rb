class User < ActiveRecord::Base
  devise :omniauthable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :uid, :token, :token_secret

  def self.find_or_create_by_evernote_oauth(auth, signed_in_resource=nil)
    user = User.where(uid: auth.uid).first
    unless user
      user = User.create(uid: auth.uid,
                         token: auth.credentials.token,
                         token_secret: auth.credentials.secret)
    end
    user
  end
end
