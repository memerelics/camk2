What's this?
=======================================================

My personal Evernote-based blog system.


camk2?
=======================================================

It's named after Calcium/calmodulin-dependent protein kinase II.

![](http://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Protein_CAMK2A_PDB_1hkx.png/635px-Protein_CAMK2A_PDB_1hkx.png)


TODO
=======================================================

app/models/adapters/livedoor.rb:
  * [  7] adapter先の記事をfetchして逆変換, 改修元ソースを取得できるように
  * [ 48] implement Adapters::Livedoor#resource
  * [ 64] <app:control> <app:draft>yes</app:draft> </app:control>
  * [ 70] EverNote tag => Livedoor blog category
  * [ 75] bodyとbody_moreに適当に分割する
  * [ 77] body_privateにguidとcontent_hashを入れて, 同期管理に使う

app/models/evernote_api.rb:
  * [ 52] tweak offset and limit

others:
  * OAuthConsumer with Logging
