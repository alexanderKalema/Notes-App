import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Notes_App/services/crud/db_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/Theme.dart';
import '../constants/langs.dart';
import '../services/cloud/cloud_note.dart';
import '../services/bloc/screening_bloc/preferene_bloc.dart';
import '../utils/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final List<String> prefs;
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;
  final _notes = DBService();

  NotesListView({
    required this.prefs,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  Future<Map> assign(String filter) async {
    DatabaseColor color = await _notes.getColor(id: filter);
    if (color.colorNumber == -1) {
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

      DatabaseColor color = await _notes.createColor(
          colType: colType, colNum: colNum, id: filter);
      return {'num': color.colorNumber, 'type': color.colorType};
    } else {
      return {'num': color.colorNumber, 'type': color.colorType};
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PreferenceProvider>(context).bloc;

    return SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 2.0,
          crossAxisSpacing: 2.0,
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final note = notes.elementAt(index);
            //  assign(note.documentId);

            // DatabaseColor color =  _notes.getColor(id: note.documentId);

            // String myType;
            // int mynum;

            return StreamBuilder(
                stream: bloc.settingpref,
                builder: (context, settingSnapshot) {
                  //  bloc.loadSettingPreferences();
                  if (settingSnapshot.hasData) {
                    final shouldWarn =
                        (settingSnapshot.data as List<String>)[1];
                    final cardChoice =
                        (settingSnapshot.data as List<String>)[0];

                    return FutureBuilder(
                        future: assign(note.documentId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            String mytype = (((snapshot.data as Map)['type'])
                                        .toString() !=
                                    null)
                                ? ((snapshot.data as Map)['type']).toString()
                                : "strong";
                            int mynum =
                                (((snapshot.data as Map)['num'] as int) != null)
                                    ? ((snapshot.data as Map)['num']) as int
                                    : 4;

                            // String mytype = (((snapshot.data as Map)['type']).toString() != null)? ((snapshot.data as Map)['type']).toString(): "strong";
                            // int mynum = (((snapshot.data as Map)['num'] as int) != null )? ((snapshot.data as Map)['num']) as int : 4;

                            switch (snapshot.connectionState) {
                              case ConnectionState.done:
                                return InkWell(
                                  onTap: () {
                                    onTap(note);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 2, right: 2, top: 25, bottom: 2),
                                    margin: EdgeInsets.all(5),
                                    width: 80,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: (cardChoice == 'Use default')
                                            ? Color(0xFFFBFEF9)
                                            : allcolors[mytype]![mynum]
                                                ['cardcolor'],
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade600,
                                            spreadRadius: 2,
                                            blurRadius: 1,
                                            offset: const Offset(0, 1),
                                          ),
                                        ]),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            note.dateModified,
                                            style: TextStyle(
                                                color: (cardChoice ==
                                                        'Use default')
                                                    ? Colors.black
                                                    : allcolors[mytype]![mynum]
                                                        ['fontcolor'],
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                                letterSpacing: 1.0),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: Text(
                                                  note.title,
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    fontFamily: "PoppinsBold",
                                                    color: (cardChoice ==
                                                            'Use default')
                                                        ? Colors.black
                                                        : allcolors[mytype]![
                                                            mynum]['fontcolor'],
                                                  ),
                                                  maxLines: 1,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                note.plainText,
                                                maxLines: 7,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: "InterRegular",
                                                  color: (cardChoice ==
                                                          'Use default')
                                                      ? Colors.black
                                                      : allcolors[mytype]![
                                                          mynum]['fontcolor'],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      if (shouldWarn ==
                                                          'true') {
                                                        final shouldDelete =
                                                            await showDeleteDialog(
                                                          context,
                                                          Themes[prefs[0]]
                                                              ['button'],
                                                          langs[prefs[1]]![37],
                                                          langs[prefs[1]]![38],
                                                          langs[prefs[1]]![32],
                                                          langs[prefs[1]]![33],
                                                        );
                                                        if (shouldDelete) {
                                                          onDeleteNote(note);
                                                        }
                                                      } else {
                                                        onDeleteNote(note);
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: (cardChoice ==
                                                              'Use default')
                                                          ? Colors.black
                                                          : allcolors[mytype]![
                                                                  mynum]
                                                              ['fontcolor'],
                                                    )),
                                                Expanded(child: SizedBox()),
                                                Text("Share",
                                                    style: TextStyle(
                                                      color: (cardChoice ==
                                                              'Use default')
                                                          ? Colors.black
                                                          : allcolors[mytype]![
                                                                  mynum]
                                                              ['fontcolor'],
                                                    )),
                                                IconButton(
                                                    onPressed: () async {
                                                      Share.share(note.title +
                                                          "    " +
                                                          note.plainText);
                                                    },
                                                    icon: Icon(
                                                      Icons.share,
                                                      color: (cardChoice ==
                                                              'Use default')
                                                          ? Colors.black
                                                          : allcolors[mytype]![
                                                                  mynum]
                                                              ['fontcolor'],
                                                    )),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              default:
                                return Center(
                                    child: SpinKitFadingFour(
                                  color: Colors.grey,
                                ));
                            }
                          } else {
                            return Center(
                                child: SpinKitFadingFour(
                              color: Colors.grey,
                            ));
                          }
                        });
                  } else {
                    return Scaffold(
                      body: const Center(
                          child: SpinKitFadingFour(
                        color: Colors.grey,
                      )),
                    );
                  }
                });
          },
          childCount: notes.length,
        ));
  }
}
