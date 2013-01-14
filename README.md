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
  * [  7] [TODO] production mode.

app/controllers/notes_controller.rb:
  * [  3] [TODO] authanticate all actions, and display "home" screen.
  * [  9] [TODO] sign_in中ユーザのもののみ表示する
  * [ 91] [TODO] user_settings['notebook_name']

app/models/evernote_api.rb:
  * [ 51] [TODO] tweak offset and limit

app/models/note.rb:
  * [  9] [TODO] @evernoteが正常にsetできないときは誤って全削してしまわない(raiseで止まる)ことをspecで確認
