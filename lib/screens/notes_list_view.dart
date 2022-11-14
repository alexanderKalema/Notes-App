import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nibret_kifel/services/crud/note_service.dart';
import 'package:share_plus/share_plus.dart';
import '../services/cloud/cloud_note.dart';
import '../utils/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;
  final _notes = NotesService();
  String? cardChoice;
  bool? shouldwarn;

  NotesListView({
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
    this.cardChoice,
    this.shouldwarn,
  });

  Future<Map> assign(String filter) async {

    await Future.delayed(Duration(milliseconds: 1500));

    DatabaseColor color = await _notes.getColor(id: filter);
    return {'num': color.colorNumber, 'type': color.colorType};
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, Color>>> allcolors = {
      'strong': [
        {'cardcolor': Color(0xFF16213E), 'fontcolor': Colors.white},
        {
          'cardcolor': Color(0xFF05299E),
          'fontcolor': Colors.white,
        },
        {
          'cardcolor': Color(0xFF462255),
          'fontcolor': Colors.white,
        },
        {
          'cardcolor': Color(0xFF8E8DBE),
          'fontcolor': Colors.white,
        },
        {
          'cardcolor': Color(0xFF370926),
          'fontcolor': Colors.white,
        },
        {
          'cardcolor': Color(0xFF0C6291),
          'fontcolor': Colors.white,
        },
        {
          'cardcolor': Color(0xFF37423D),
          'fontcolor': Colors.white,
        },
        {
          'cardcolor': Color(0xFF171614),
          'fontcolor': Colors.white,
        },
        {
          'cardcolor': Color(0xFFB1740F),
          'fontcolor': Colors.white,
        },
        {
          'cardcolor': Color(0xFF32533D),
          'fontcolor': Colors.white,
        },
        {
          'cardcolor': Color(0xFF8B6220),
          'fontcolor': Colors.white,
        },
        {
          'cardcolor': Color(0xFF720E07),
          'fontcolor': Colors.white,
        },
        {
          'cardcolor': Color(0xFF0C6291),
          'fontcolor': Colors.white,
        },
        {
          'cardcolor': Color(0xFF456990),
          'fontcolor': Colors.white,
        },
        {
          'cardcolor': Color(0xFF9A8873),
          'fontcolor': Colors.white,
        },
        {
          'cardcolor': Color(0xFF3A2618),
          'fontcolor': Colors.white,
        },
        {
          'cardcolor': Color(0xFFFB5012),
          'fontcolor': Colors.white,
        },
      ],
      'weak': [
        {
          'cardcolor': Color(0xFFFBFEF9),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFFD8CFAF),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFF4ECDC4),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFFFF6B6B),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFFDDBDD5),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFF947BD3),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFFA9E4EF),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFF96F550),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFFCAC2B5),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFFECDCC9),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFFD0A98F),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFFCFCFCF),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFFFDB833),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFFFFD07B),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFFA2AEBB),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFF98A6D4),
          'fontcolor': Colors.black,
        },
        {
          'cardcolor': Color(0xFF8CBA80),
          'fontcolor': Colors.black,
        },
      ],
    };

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

          return FutureBuilder(
              future: assign(note.documentId),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  String mytype =
                      (((snapshot.data as Map)['type']).toString() != null)
                          ? ((snapshot.data as Map)['type']).toString()
                          : "strong";
                  int mynum = (((snapshot.data as Map)['num'] as int) != null)
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
                          margin: EdgeInsets.all(5),
                          width: 80,
                          height: 100,
                          decoration: BoxDecoration(
                              color: (cardChoice == 'default')
                                  ? Color(0xFFFBFEF9)
                                  : allcolors[mytype]![mynum]['cardcolor'],
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      note.dateModified,
                                      style: TextStyle(
                                          color: (cardChoice == 'default')
                                              ? Colors.black
                                              : allcolors[mytype]![mynum]
                                                  ['fontcolor'],
                                          fontFamily: "TailwindLight",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          letterSpacing: 1.2),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          if (shouldwarn ?? true) {
                                            final shouldDelete =
                                                await showDeleteDialog(context);
                                            if (shouldDelete) {
                                              onDeleteNote(note);
                                            }
                                          } else {
                                            onDeleteNote(note);
                                          }
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: (cardChoice == 'default')
                                              ? Colors.black
                                              : allcolors[mytype]![mynum]
                                                  ['fontcolor'],
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        note.title,
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontFamily: "PoppinsBold",
                                          color: (cardChoice == 'default')
                                              ? Colors.black
                                              : allcolors[mytype]![mynum]
                                                  ['fontcolor'],
                                        ),
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      note.text,
                                      maxLines: 8,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: "InterRegular",
                                        color: (cardChoice == 'default')
                                            ? Colors.black
                                            : allcolors[mytype]![mynum]
                                                ['fontcolor'],
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
                                      Expanded(child: SizedBox()),
                                      Text("Share",
                                          style: TextStyle(
                                            color: (cardChoice == 'default')
                                                ? Colors.black
                                                : allcolors[mytype]![mynum]
                                                    ['fontcolor'],
                                          )),
                                      IconButton(
                                          onPressed: () async {
                                            Share.share(note.title +"    " + note.text);
                                          },
                                          icon: Icon(
                                            Icons.share,
                                            color: (cardChoice == 'default')
                                                ? Colors.black
                                                : allcolors[mytype]![mynum]
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
                            color: Color(0xFFffcb47),
                          ));
                  }
                } else {
                  return Center(
                      child: SpinKitFadingFour(
                    color: Color(0xFFffcb47),
                  ));
                }
              });
        },
        childCount: notes.length,
      ),

      // SliverFillRemaining(
      // hasScrollBody: true,
      // child:
      // Wrap(
      // spacing: 15,
      //   runAlignment: WrapAlignment.spaceAround,
      //           children: [
      //
      //            ... noteList.map((individuals) {
      //
      //               return
      //                 InkWell(
      //                               onTap: () {
      //                                 onTap(individuals);
      //                               },
      //                               child: Container(
      //                                 margin: EdgeInsets.symmetric(vertical: 7),
      //                                 padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      //                                 width: (Sizes.getTotalWidth(context) - 60)/2,
      //                                 height:180,
      //                                 decoration: BoxDecoration(
      //                                     color: Colors.white,
      //                                     borderRadius: BorderRadius.circular(15),
      //                                     // boxShadow: [
      //                                     //   BoxShadow(blurRadius: 3, offset: Offset(5, 5)),
      //                                     //   BoxShadow(blurRadius: 3, offset: Offset(-5, -5))
      //                                     // ]
      //                                   ),
      //                                 child: Text(
      //                                   individuals.text,
      //                                   maxLines: 1,
      //                                   softWrap: true,
      //                                   overflow: TextOverflow.ellipsis,
      //                                 ),
      //                               ),
      //                             );
      //             } ).toList()

      // ]))
    );
    // ListView.builder(
    //   shrinkWrap: true,
    //   itemCount:  notes.length,
    //   itemBuilder: (context, index) {
    //     final note = notes.elementAt(index);
    //     return
    //       Row(
    //           children: [
    //
    //             InkWell(
    //             onTap: () {
    //               onTap(note);
    //             },
    //             child: Container(
    //               margin: EdgeInsets.all(20),
    //               padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    //               width: 80,
    //               height: 100,
    //               decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.circular(15),
    //                   boxShadow: [
    //                     BoxShadow(blurRadius: 3, offset: Offset(5, 5)),
    //                     BoxShadow(blurRadius: 3, offset: Offset(-5, -5))
    //                   ]),
    //               child: Text(
    //                 note.text,
    //                 maxLines: 1,
    //                 softWrap: true,
    //                 overflow: TextOverflow.ellipsis,
    //               ),
    //             ),
    //           ),
    //           ]
    //       );
    //
    //     //   ListTile(
    //     //   onTap: () {
    //     //     onTap(note);
    //     //   },
    //     //   title: Text(
    //     //     note.text,
    //     //     maxLines: 1,
    //     //     softWrap: true,
    //     //     overflow: TextOverflow.ellipsis,
    //     //   ),
    //     //   trailing: IconButton(
    //     //     onPressed: () async {
    //     //       final shouldDelete = await showDeleteDialog(context);
    //     //       if (shouldDelete) {
    //     //         onDeleteNote(note);
    //     //       }
    //     //     },
    //     //     icon: const Icon(Icons.delete),
    //     //   ),
    //     // );
    //     //  },
    //     //)
    //   });
  }
}
