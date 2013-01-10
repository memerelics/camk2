# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  describe "*able" do
    subject { User.new }

    # trackable fields
    it { should respond_to(:last_sign_in_at) }
    it { should respond_to(:current_sign_in_at) }
    it { should respond_to(:last_sign_in_ip) }
    it { should respond_to(:current_sign_in_ip) }
    it { should respond_to(:sign_in_count) }
  end
end
