require 'spec_helper'

describe "notes/index" do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    # controller.stub!(:signed_in?).and_return(false)
  end
end
