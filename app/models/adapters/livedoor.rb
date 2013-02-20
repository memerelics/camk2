# -*- coding: utf-8 -*-
require 'builder'
class Adapters::Livedoor < Adapters::Base
  class InvalidLogin < StandardError; end
  class ResponseError < StandardError; end

  # TODO: adapter先の記事をfetchして逆変換, 改修元ソースを取得できるように

  # Atom Publishing Protocol 日本語訳
  #   http://www.ricoh.co.jp/src/rd/webtech/rfc5023_ja.html
  #
  # Atom Pub APIについて - livedoor ブログ ヘルプセンター
  #   http://help.blogpark.jp/archives/52288925.html
  BLOG_PROVIDER = "livedoor"

  attr_accessor :livedoor_id, :api_key, :http

  def initialize(livedoor_id, api_key)
    @livedoor_id = livedoor_id
    @api_key = api_key
    @http = Net::HTTP.start("#{BLOG_PROVIDER}.blogcms.jp", 80)
  end

  def wsse
    WSSE::header(livedoor_id, api_key)
  end

  # > メンバ URI は、クライアントが HTTP の GET、PUT、DELETE を用いて
  # > メンバソースの検索・編集・削除を行うことを許可する。
  #   /atom/BLOG_PROVIDER/BLOG_NAME
  #     * /article            ( 記事のコレクションURI)
  #     * /article/ARTICLE_ID ( 記事のメンバURI)
  #     * /category           ( カテゴリ文書URI)
  #     * /image              ( 画像のコレクションURI)
  #     * /image/IMAGE_ID     ( 画像のメンバURI)
  def resources(name)
    res  = @http.get("/atom/#{BLOG_PROVIDER}/#{livedoor_id}/#{name}", {'X-WSSE' => wsse})
    raise(Adapters::Livedoor::ResponseError) if res.code != "200"
    parsed = Hashie::Mash.new(Hash.from_xml(res.body))
    parsed.feed.try(:entry)
  end

  def articles   ; resources("article")  ; end
  def categories ; resources("category") ; end
  def images     ; resources("image")    ; end

  def resource(name, id)
    # TODO implement Adapters::Livedoor#resource
  end

  def article(id) ; resource("article", id)  ; end
  def image(id)   ; resource("image", id)    ; end


  # > コレクションにメンバを追加するために、
  # > クライアントはコレクションの URI に対して POST リクエストを送る。
  # Noteオブジェクトを引数に取る
  def post(note)
    @http.post("/atom/#{BLOG_PROVIDER}/#{livedoor_id}/article", build_xml(note), {'X-WSSE' => wsse})
  end

  # author>name, id 等は上書きされる
  # "id"=>"tag:livedoor.blogcms.jp,2013-01-25:article-blog/mastertest.23229248",
  # TODO: <app:control> <app:draft>yes</app:draft> </app:control>
  def build_xml(note)
    x = Builder::XmlMarkup.new
    x.instruct!
    x.entry(entry_attributes){
      x.title(note.title)
      # TODO: EverNote tag => Livedoor blog category
      # x.category("term" => "お知らせ","scheme" => category_scheme)

      x.blogcms(:source){
        x.blogcms(:body){ x.cdata! note.content_html }
        # TODO: bodyとbody_moreに適当に分割する
        # x.blogcms(:more){ x.cdata! "<p>ついかー</p>" }
        # TODO: body_privateにguidとcontent_hashを入れて, 同期管理に使う
        # x.blogcms(:private){ x.cdata! "<p>priiiivate</p>" }
      }
    }
  end

  def entry_attributes
    { "xmlns" => "http://www.w3.org/2005/Atom",
      "xmlns:app" => "http://www.w3.org/2007/app",
      "xmlns:blogcms" => "http://blogcms.jp/-/spec/atompub/1.0/" }
  end

  def category_scheme
    "http://#{BLOG_PROVIDER}.blogcms.jp/blog/#{livedoor_id}/category"
  end

  # def post_with_mechanize(note)
  # agent.get("https://member.livedoor.com/login/") {|page|

  #   # ログイン処理
  #   form = page.form_with(name: "loginForm")
  #   form.livedoor_id = livedoor_id
  #   form.password = password
  #   page2 = form.submit
  #   # ログイン失敗時
  #   raise Adapters::Livedoor::InvalidLogin if page2.form_with(name: "loginForm")

  #   cms_page =  page2.link_with(href: /r\/user_blogcms/).click
  #   edit_page = cms_page.link_with(href: /\/blog\/mastertest\/article\/edit/).click
  #   article_form = edit_page.form_with(name: "ArticleForm")
  #   # 隠されたtextareaにpreview部分, 続きを読む(ここまでで公開記事全体), プライベートの3つに分けて登録
  #   article_form.title = note.title
  #   article_form.body = "<p>hhhhhhhhhhhhhhh</p>"
  #   article_form.body_more = note.content_html
  #   article_form.body_private = ""

  #   # 記事投稿
  #   article_form.submit
  # }
  # end

end
