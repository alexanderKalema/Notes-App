import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Notes_App/services/crud/db_service.dart';
import 'package:provider/provider.dart';
import '../constants/Theme.dart';
import '../constants/langs.dart';
import '../constants/routes.dart';
import '../models/sample_container.dart';
import '../services/auth/auth_service.dart';
import '../services/cloud/cloud_note.dart';
import 'package:Notes_App/screens/notes_list_view.dart';
import 'package:Notes_App/services/cloud/firebase_cloud_storage.dart';
import 'package:intl/intl.dart';

import '../services/bloc/screening_bloc/preferene_bloc.dart';

class NotesView extends StatefulWidget {
  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  late DBService _note;
  late TextEditingController searchController;
  String? res;

  StreamController<String> bigcontroller = StreamController<String>();

  String get userId => AuthService.firebase().currentUser!.id;

  void initState() {
    _notesService = FirebaseCloudStorage();
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PreferenceProvider>(context).bloc;

    return StreamBuilder(
        stream: bloc.mypref,
        builder: (context, prefsnapshot) {
          if (prefsnapshot.hasData) {
            final choosenTheme = (prefsnapshot.data as List)[0] ?? '';
            final String choosenLang = (prefsnapshot.data as List)[1] ?? '';

            return Scaffold(
                body: Container(
                    color: Themes[choosenTheme]["primary"],
                    child: Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.only(right: 20, left: 20, top: 80),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Container()),
                                  Text(
                                    langs[choosenLang]![22],
                                    style: TextStyle(
                                        fontSize: 40,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "TailwindRegular"),
                                  ),
                                  Expanded(child: Container()),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(settingRoute);
                                      },
                                      icon: Icon(
                                        Icons.settings,
                                        color: (choosenTheme == 'assets/images/Themes/first.png')? Themes[choosenTheme]["secondary"] :Themes[choosenTheme]["button"],
                                        size: 30,
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),

                              // Leveled button
                              Row(
                                children: [
                                  SampleContainer(
                                    mychild: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(25, 20, 20, 20),
                                      child: TextField(
                                        controller: searchController,
                                        onChanged: (text) {
                                          bigcontroller.add(text);
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon: Icon(
                                            Icons.search_rounded,
                                            color: Themes[choosenTheme]
                                                ["primary"],
                                          ),
                                          hintStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w100,
                                            fontFamily: "NeofontRoman",
                                            color: Colors.grey.withOpacity(0.5),
                                          ),
                                          border: InputBorder.none,
                                          hintText: langs[choosenLang]![23],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(60),
                                    topRight: Radius.circular(60))),
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 30),
                            child: Stack(children: [
                              StreamBuilder(
                                  initialData: "",
                                  stream: bigcontroller.stream,
                                  builder: (context, snapshot) {
                                    return StreamBuilder(
                                      stream: _notesService.allNotes(
                                          ownerUserId: userId,
                                          searchedText:
                                              snapshot.data.toString()),
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                          case ConnectionState.active:
                                            if (snapshot.hasData &&
                                                snapshot.data.toString() !=
                                                    '()') {
                                              final allNotes = snapshot.data
                                                  as Iterable<CloudNote>;
                                              return CustomScrollView(slivers: [
                                                NotesListView(
                                                  notes: allNotes,
                                                  onDeleteNote: (note) async {
                                                    await _notesService
                                                        .deleteNote(
                                                            documentId: note
                                                                .documentId);
                                                    await _note.deleteColor(
                                                        id: note.documentId);
                                                  },
                                                  onTap: (note) {
                                                    var now = DateTime.now();
                                                    var formatterDate =
                                                        DateFormat('dd/MM/yy');
                                                    var formatterTime =
                                                        DateFormat('kk:mm');
                                                    String actualDate =
                                                        formatterDate
                                                            .format(now);
                                                    String actualTime =
                                                        formatterTime
                                                            .format(now);

                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      createOrUpdateNoteRoute,
                                                      arguments: [
                                                        note,
                                                        " ${actualDate + "    " + actualTime}"
                                                      ],
                                                    );
                                                  },
                                                  prefs: (prefsnapshot.data
                                                      as List<String>),
                                                ),
                                              ]);
                                            } else {
                                              return Center(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image(
                                                        image: AssetImage(
                                                            "assets/images/empty.png"),
                                                        height: 200,
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        langs[choosenLang]![24],
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFa0acb8),
                                                            fontSize: 13,
                                                            fontFamily:
                                                                "PoppinsRegular"),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          default:
                                            return Center(
                                                child: SpinKitFadingFour(
                                              color: Themes[choosenTheme]
                                                  ["button"],
                                            ));
                                        }
                                      },
                                    );
                                  }),
                              Positioned(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 18),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40)),
                                        color: Themes[choosenTheme]["button"],
                                        // shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(20, 20),
                                            blurRadius: 40,
                                          ),
                                          BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(-1, -1),
                                            blurRadius: 7,
                                          )
                                        ]),
                                    child: Material(
                                      color: Themes[choosenTheme]["button"],
                                      borderRadius: BorderRadius.circular(40),
                                      elevation: 10,
                                      child: IconButton(
                                        iconSize: 50,
                                        alignment: Alignment.center,
                                        onPressed: () {
                                          var now = DateTime.now();
                                          var formatterDate =
                                              DateFormat('dd/MM/yy');
                                          var formatterTime =
                                              DateFormat('kk:mm');
                                          String actualDate =
                                              formatterDate.format(now);
                                          String actualTime =
                                              formatterTime.format(now);

                                          Navigator.of(context).pushNamed(
                                            createOrUpdateNoteRoute,
                                            arguments: [
                                              null,
                                              " ${actualDate + "    " + actualTime} "
                                            ],
                                          );
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        )
                      ],
                    )));
          } else {
            return Scaffold(
              body: Center(
                  child: SpinKitFadingFour(
                color: Colors.grey,
              )),
            );
          }
        });
  }
}
