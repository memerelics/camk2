# -*- coding: utf-8 -*-
class Adapters::Livedoor
  attr_accessor :agent, :livedoor_id, :password

  attr_accessor :agent, :livedoor_id, :password

  def initialize(livedoor_id, password)
    @livedoor_id = livedoor_id
    @password = password
    @agent = Mechanize.new {|agent|
      agent.user_agent = 'Mozilla/5.0 (compatible; MSIE 9.0; Windows Phone OS 7.5; Trident/5.0; IEMobile/9.0; FujitsuToshibaMobileCommun; IS12T; KDDI)'
      agent.ssl_version, agent.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE
    }
  end

  def post(note)
    agent.get("https://member.livedoor.com/login/") {|page|
      form = page.form_with(name: "loginForm")
      form.livedoor_id = livedoor_id
      form.password = password
      page2 = form.submit
      cms_page =  page2.link_with(href: /r\/user_blogcms/).click
      edit_page = cms_page.link_with(href: /\/blog\/mastertest\/article\/edit/).click
      article_form = edit_page.form_with(name: "ArticleForm")
      # 隠されたtextareaにpreview部分, 続きを読む(ここまでで公開記事全体), プライベートの3つに分けて登録
      article_form.title = note.title
      # TODO: bodyとbody_moreに適当に分割する
      article_form.body = note.content_html
      article_form.body_more = note.content_html
      article_form.body_private = ""

      # 記事投稿
      article_form.submit
    }

  end
end
