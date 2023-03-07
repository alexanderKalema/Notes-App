import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill hide Text;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Notes_App/models/get_arguments.dart';
import '../services/auth/auth_service.dart';
import '../services/cloud/cloud_note.dart';
import '../services/cloud/firebase_cloud_storage.dart';
import '../services/crud/db_service.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  _CreateUpdateNoteViewState createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  late final DBService _name;
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;

  TextEditingController _titleController =
      TextEditingController(text: 'Untitled Document');

  late quill.QuillController _controller;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _name = DBService();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.removeListener(_textControllerListener);
    _controller.removeListener(_textControllerListener);
    super.dispose();
    _titleController.dispose();
  }

  void close() async {
    await _deleteNoteIfTextIsEmpty();
    await _saveNoteIfTextNotEmpty();
    Navigator.pop(context);
  }

  void _setupTextControllerListener() {
    _controller.addListener(_textControllerListener);
    _titleController.addListener(_textControllerListener);
  }

  void _textControllerListener() async {
    final widgetNote = context.getArgument<List<dynamic>>();
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _controller.document.toPlainText().trim();
    final title = _titleController.text;

    var json = jsonEncode(_controller.document.toDelta().toJson());
    if (text.isNotEmpty || title.isNotEmpty) {
      await _notesService.updateNote(
        documentId: note.documentId,
        plainText: text,
        jsonText: json,
        title: title,
        date: widgetNote![1],
      );
    }
  }

  _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    print("dcc forever");
    if (_controller.document.toPlainText().trim().isEmpty &&
        (_titleController.text == 'Untitled Document') &&
        note != null) {
      print("marvel?");
      await _notesService.deleteNote(documentId: note.documentId);
      await _name.deleteColor(id: note.documentId);
    }
  }

  _saveNoteIfTextNotEmpty() async {
    final widgetNote = context.getArgument<List<dynamic>>();
    final note = _note;

    var json = jsonEncode(_controller.document.toDelta().toJson());
    final title = _titleController.text;
    print(_controller.document.toPlainText().trim().isNotEmpty);
    print('from saving am coming ${json} ${title}');
    if (note != null &&
        (_controller.document.toPlainText().trim().isNotEmpty ||
            title != 'Untitled Document')) {
      print("so your coming here");
      await _notesService.updateNote(
        documentId: note.documentId,
        plainText: _controller.document.toPlainText(),
        jsonText: json,
        title: title,
        date: widgetNote![1],
      );
      await adder();
    }
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<List<dynamic>>();

    if (widgetNote![0] != null) {
      _note = widgetNote[0];
      var myJSON = jsonDecode(''' ${widgetNote[0].jsonText} ''');
      _controller = quill.QuillController(
        document: quill.Document.fromJson(myJSON),
        selection: TextSelection.collapsed(offset: 0),
      );

      _titleController.text = widgetNote[0].title;

      return widgetNote[0];
    } else {
      final existingNote = _note;
      print("pleassse come here ${existingNote}");
      int colNum;
      String colType;

      int randomNumber = Random().nextInt(2);
      if (randomNumber == 0) {
        colType = "strong";
      } else {
        colType = "weak";
      }

      int myrandomNumber = Random().nextInt(17);
      colNum = myrandomNumber;

      if (existingNote != null) {
        print("dccc22");
        return existingNote;
      }

      _controller = quill.QuillController(
        document: quill.Document(),
        selection: TextSelection.collapsed(offset: 0),
      );

      final currentUser = AuthService.firebase().currentUser!;
      final userId = currentUser.id;

      final nameuser = await _name.getNames(id: userId);

      final newNote = await _notesService.createNewNote(
          ownerUserId: userId,
          firstName: nameuser.firstName,
          lastName: nameuser.lastName);
      _note = newNote;
      await _name.createColor(
          colType: colType, colNum: colNum, id: newNote.documentId);

      return newNote;
    }
  }

  Future<void> adder() async {
    final note = _note;
    int colNum;
    String colType;

    int randomNumber = Random().nextInt(2);
    if (randomNumber == 0) {
      colType = "strong";
    } else {
      colType = "weak";
    }

    int myrandomNumber = Random().nextInt(17);
    colNum = myrandomNumber;

    // print("am i coming here");

    await _name.updateColor(
        colType: colType, colNum: colNum, id: note!.documentId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          _setupTextControllerListener();
          if (snapshot.hasData && !snapshot.hasError
          ) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueGrey,
                        width: 0.1,
                      ),
                    ),
                  ),
                ),
                actions: [
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () {
                      close();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF555555),
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  const Image(
                    image: AssetImage("assets/images/launcher_icon.png"),
                    height: 60,
                    width: 40,
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 180,
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 10),
                      ),
                      onSubmitted: (value) {
                        // updateTitle(ref, value)
                      },
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      onPressed: () async {
                        // var json = jsonEncode(
                        //     _controller.document.toDelta().toJson());
                        //    print("json is ${json}");
                        // print(
                        //   "to plain text is ${_controller.document.toPlainText()}");
                        await _saveNoteIfTextNotEmpty();
                      },
                      label: Text("Save")),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              body: Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: quill.QuillEditor.basic(
                            controller: _controller,
                            //  embedBuilders: FlutterQuillEmbeds.builders(),
                            readOnly: false, // true for view only mode
                          ),
                        ),
                      ),
                      quill.QuillToolbar.basic(controller: _controller),
                    ],
                  )),
            );
          } else {
            return  Scaffold(
              body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          Icons.signal_wifi_connected_no_internet_4_outlined,
                      color:Colors.grey,
                      size:90),
                      SizedBox(height: 20,),
                      SpinKitFadingFour(
                color: Colors.grey,
              ),
                    ],
                  )),
            );
          }
        });
  }
}
