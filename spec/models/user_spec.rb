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

  describe "relations" do
    subject { User.new }
    it { should_not respond_to(:unknown_ids) }
    describe "has_many :notes" do
      it { should     respond_to(:note_ids) }
      it { should     respond_to(:notes) }
      it { should_not respond_to(:note_id) }
    end
    describe "has_many :adapters" do
      it { should     respond_to(:adapter_ids) }
      it { should     respond_to(:adapters) }
      it { should_not respond_to(:adapter_id) }
    end
  end
end
