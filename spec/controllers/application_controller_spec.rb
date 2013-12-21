# coding: utf-8
require 'spec_helper'

describe ApplicationController do
  describe "#evernote" do
    context "if signed_in" do
      before do
        controller.stub!(:signed_in?).and_return true
        user = mock(User)
        user.stub(token: 'hoge')
        controller.stub!(:current_user).and_return(user)
        EvernoteApi.stub!(:new).and_return double("boogie")
      end
      it { controller.evernote.should_not be_nil }
    end
    context "unless signed_in" do
      before do
        controller.stub!(:signed_in?).and_return false
      end
      it { controller.evernote.should be_nil }
    end
  end

end
