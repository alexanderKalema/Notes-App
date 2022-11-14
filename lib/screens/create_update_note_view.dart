import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:nibret_kifel/models/sample_text_field.dart';
import 'package:nibret_kifel/services/auth/auth_service.dart';

import 'package:nibret_kifel/models/get_arguments.dart';
import 'package:nibret_kifel/services/cloud/cloud_note.dart';
import 'package:nibret_kifel/services/cloud/firebase_cloud_storage.dart';
import 'package:nibret_kifel/services/crud/note_service.dart';
import 'package:replay_bloc/replay_bloc.dart';

class CreateUpdateNoteView extends StatefulWidget{
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  _CreateUpdateNoteViewState createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;
  late final TextEditingController _titleController;
  late final mycubit;
  late final NotesService _name;

  @override
  void initState() {
    mycubit = ListCubit();
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    _titleController = TextEditingController();
    _name = NotesService();
    super.initState();
  }

  void _textControllerListener() async {
    final widgetNote = context.getArgument<List<dynamic>>();
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    final title = _titleController.text;






if(text.isNotEmpty|| title.isNotEmpty) {
  await _notesService.updateNote(
    documentId: note.documentId,
    text: text,
    title: title,
    date: widgetNote![1],
  );
}

  }


  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
    _titleController.removeListener(_textControllerListener);
    _titleController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<List<dynamic>>();

    if (widgetNote![0] != null) {
      _note = widgetNote[0];
      _textController.text = widgetNote[0].text;
      _titleController.text = widgetNote[0].title;
      return widgetNote[0];
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }


    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final nameuser = await _name.getNames(id: userId);
    final newNote = await _notesService.createNewNote(ownerUserId: userId, firstName: nameuser.firstName , lastName: nameuser.lastName);
    _note = newNote;

    return newNote;

  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;

    if (_textController.text.isEmpty && _titleController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final widgetNote = context.getArgument<List<dynamic>>();
    final note = _note;





    final text = _textController.text;
    final title = _titleController.text;
    if (note != null && (text.isNotEmpty || title.isNotEmpty)) {

      //
      // int colNum;
      // String colType;
      //
      // int randomNumber = Random().nextInt(2);
      // if(randomNumber == 0) {colType = "strong";}
      // else {colType = "weak";}
      //
      //
      // int myrandomNumber = Random().nextInt(17);
      // colNum = myrandomNumber;
      //
      // print("am i coming here");
      // await _name.createColor(colType: colType, colNum: colNum, id: note.documentId);
      //
      //

      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
        title: title,
        date: widgetNote![1],
      );
    }
  }

  Future<void> adder() async {
    final note = _note;
    int colNum;
    String colType;

    int randomNumber = Random().nextInt(2);
    if(randomNumber == 0) {colType = "strong";}
    else {colType = "weak";}


    int myrandomNumber = Random().nextInt(17);
    colNum = myrandomNumber;

   // print("am i coming here");

    await _name.createColor(colType: colType, colNum: colNum, id: note!.documentId);

  }

  @override
  void dispose() async {
    super.dispose();
     mycubit.close();
     mycubit.clearHistory();
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    await adder();
    _textController.dispose();
    _titleController.dispose();


  }

  @override
  Widget build(BuildContext context) {
    final widgetNote = context.getArgument<List<dynamic>>();
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 10, right: 10, top: 60),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:  [
                IconButton(
                  onPressed: () {

                    //dispose();
                    Navigator.pop(context);

                    },
                  icon: Icon(Icons.arrow_back,color: Color(0xFF555555),size: 30,),
                ),
                Expanded(child: SizedBox()),
                IconButton(
                    onPressed:() {
                        mycubit.undo();

                      _textController.text =  mycubit.state.items.last;

                    },
                    icon: Icon(Icons.undo_outlined,color: Color(0xFF555555),size: 30,)),

                SizedBox(width: 10,),
                IconButton(
                    onPressed: () {
                      mycubit.redo();
                      _textController.text =  mycubit.state.items.last;
                    }, icon: Icon(Icons.redo_outlined,color: Color(0xFF555555),size: 30,)),
                SizedBox(width: 10,),

                IconButton(onPressed: () {

                  Navigator.pop(context);

                } , icon: Icon(Icons.check, color: Color(0xFF555555), size: 30,))
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextFieldForEditing( controller: _titleController,),
            ),
            SizedBox(height: 30,),

         FutureBuilder(

              future:

              createOrGetExistingNote(context),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    _setupTextControllerListener();
                    return Expanded(
                      child: SingleChildScrollView(

                          child:TextField(

                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                          onChanged:  (value){

                          mycubit.newItem(value);
                            //thisList = ListCubit.myList;

                          },
                          style: TextStyle(
                        fontSize: widgetNote![2] as double,
                          height: 2.0
                      ),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "Body goes here"),
                      )),
                    );
                  default:
                    return CircularProgressIndicator();
                }
              },
            ),




          ],
        ),
      ),
    );
  }
}


class ListData{
  final List<String> items;
  ListData(this.items);
}


class ListCubit extends ReplayCubit<ListData>{

    List myList = [];

  ListCubit(): super(ListData([]));

  void newItem(String text){
    final items = [... state.items];
    items.add(text);

    myList = items;
    emit(ListData (items));

  }

}