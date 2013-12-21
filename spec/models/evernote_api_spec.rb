# coding: utf-8
require 'spec_helper'

# RSpecでモックを使って外部サービスに依存するコードのテストを書いてみた - ぬいぐるみライフ(仮)
# http://d.hatena.ne.jp/mickey24/20100302/1267464477
describe EvernoteApi do
  # EvernoteApi.newで通信させたくない => EvernoteApi.newをstubする?
  # いや, initialize内で使ってるAPI通信をすべてstubすればいいのか.
  before do
    @dummy_user = mock(User.new)
    @dummy_user.stub!(:token).and_return('dummy_token')

    Thrift::HTTPClientTransport.stub!(new: nil)
    Thrift::BinaryProtocol.stub!(new: nil)

    us = mock(Evernote::EDAM::UserStore::UserStore::Client)
    Evernote::EDAM::UserStore::UserStore::Client.stub!(new: us)
    us.stub!(checkVersion: true,
             getNoteStoreUrl: 'http://note_store_url/')
  end

  # 暗黙的にEvernoteApiクラスのインスタンスがsubjectになる.
  # newに引数を渡したい時は明示的にsubjectを指定
  # ref: http://blog.davidchelimsky.net/2012/05/13/spec-smell-explicit-use-of-subject/
  describe 'EvernoteApi.new' do
    subject { EvernoteApi.new(@dummy_user.token) }

    # attributes
    it { should respond_to(:notestore) }
    it { should respond_to(:token) }
    its(:token) { should eq 'dummy_token' }

    # instance methods
    it { should respond_to(:notebooks) }
    it { should respond_to(:notes_in_a_notebook) }
  end
end
