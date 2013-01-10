# -*- coding: utf-8 -*-
require 'spec_helper'

describe Note do
  it "has a valid factory" do
    FactoryGirl.create(:note).should be_valid
  end
  it "is invalid without guid" do
    FactoryGirl.build(:note, guid: nil).should_not be_valid
  end
  it "is invalid without content_hash" do
    FactoryGirl.build(:note, content_hash: nil).should_not be_valid
  end
  it "is invalid without content_raw" do
    FactoryGirl.build(:note, content_raw: nil).should_not be_valid
  end
  it "is invalid without title" do
    FactoryGirl.build(:note, title: nil).should_not be_valid
  end
end
