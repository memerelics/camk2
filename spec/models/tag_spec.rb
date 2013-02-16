# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tag do
  describe 'validations' do
    it "has a valid factory" do
      FactoryGirl.create(:tag).should be_valid
    end
    it "name should be unique" do
      FactoryGirl.create(:tag)
      FactoryGirl.build(:tag).should_not be_valid
    end
  end
end
