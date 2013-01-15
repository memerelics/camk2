What's this?
=======================================================

My personal Evernote-based blog system.


camk2?
=======================================================

It's named after Calcium/calmodulin-dependent protein kinase II.

![](http://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Protein_CAMK2A_PDB_1hkx.png/635px-Protein_CAMK2A_PDB_1hkx.png)


TODO
=======================================================

app/controllers/application_controller.rb:
  * [  7] production mode.

app/models/adapters/livedoor.rb:
  * [ 32] bodyとbody_moreに適当に分割する
  * [ 35] body_privateにguidとcontent_hashを入れて, 同期管理に使う

app/models/evernote_api.rb:
  * [ 52] tweak offset and limit

