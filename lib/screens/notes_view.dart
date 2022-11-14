import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nibret_kifel/models/get_arguments.dart';
import 'package:nibret_kifel/models/sample_text_field.dart';
import '../constants/routes.dart';
import '../models/sample_container.dart';
import '../services/auth/auth_service.dart';
import '../services/cloud/cloud_note.dart';
import 'package:nibret_kifel/screens/notes_list_view.dart';
import 'package:nibret_kifel/services/cloud/firebase_cloud_storage.dart';
import 'package:intl/intl.dart';

import 'create_update_note_view.dart';

 class NotesView extends StatefulWidget {
  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  late var myList = null;
  late TextEditingController searchController;
  String? res;

  Map original =  {
    "cardColor" : "default",
  "fontSize" : 12.0,
  "deleteConfirm": true,
  };

  StreamController<Map> controller = StreamController<Map>.broadcast();
  StreamController<String> bigcontroller = StreamController<String>();

  String get userId => AuthService.firebase().currentUser!.id;


  void initState() {
    _notesService = FirebaseCloudStorage();
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return
      Scaffold(
        body:
        Container(
          color:Color(0xFFffcb47),

          child:
        Column(
              children: [
                  Container(
                    padding: EdgeInsets.only(right: 20,left:20, top:80),
                    child: Column(
                      children: [Row(
                        children: [
                          Expanded(child: Container()),
                          const Text("My Notes", style: TextStyle(letterSpacing:1.3,fontSize: 34, fontFamily: "TailwindSRegular", fontWeight: FontWeight.w900),),
                          Expanded(child: Container()),
                           IconButton( onPressed:()async  {

                             original = await Navigator.of(context)
                                   .pushNamed(settingRoute) as Map ;

                                controller.add(original);


                              },
                               icon: Icon(Icons.settings, color: Colors.deepOrangeAccent , size: 30,))
                        ],
                      ),
                        SizedBox(height: 40,),

                        // Leveled button
                        Row(
                          children: [




                        SampleContainer(
                        mychild: Container(
                        padding: EdgeInsets.fromLTRB(25,20,20,20),
          child: TextField(

            controller: searchController,

            onChanged: (text){
               bigcontroller.add(text);
            },

            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search_rounded , color:Color(0xFFffcb47) ,),

              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w100,
                fontFamily: "NeofontRoman",
                color: Colors.grey.withOpacity(0.5),
              ),
              border: InputBorder.none,

              hintText: "Search",
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
                          color:Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight:Radius.circular(60) )
                      ),
                    padding: EdgeInsets.only(left:10, right: 10 , top:30),
                    child: Stack(
                        children:[


                           StreamBuilder(
                             initialData: original,
                             stream: controller.stream,
                             builder: (context, snapshot) {


                                String mycardColor = (snapshot.data as Map)['cardColor'] ;
                                bool shouldwarn = (snapshot.data as Map)['deleteConfirm'] ;
                                double mysize = (snapshot.data as Map) ['fontSize'] as double;


                               return
                               StreamBuilder(
                               initialData: "",
                               stream: bigcontroller.stream,
                                  builder: (context, snapshot)
                                {



                                  return StreamBuilder(
                                    stream: _notesService.allNotes(
                                        ownerUserId: userId,
                                        searchedText: snapshot.data.toString()),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                        case ConnectionState.active:
                                          if (snapshot.hasData &&
                                              snapshot.data.toString() !=
                                                  '()') {
                                            final allNotes =
                                            snapshot.data as Iterable<
                                                CloudNote>;
                                            return CustomScrollView(
                                                slivers: [

                                                  NotesListView(
                                                    shouldwarn: shouldwarn,
                                                    cardChoice: mycardColor,
                                                    notes: allNotes,
                                                    onDeleteNote: (note) async {
                                                      await _notesService
                                                          .deleteNote(
                                                          documentId: note
                                                              .documentId);
                                                    },
                                                    onTap: (note) {
                                                      var now = DateTime.now();
                                                      var formatterDate = DateFormat(
                                                          'dd/MM/yy');
                                                      var formatterTime = DateFormat(
                                                          'kk:mm');
                                                      String actualDate = formatterDate
                                                          .format(now);
                                                      String actualTime = formatterTime
                                                          .format(now);

                                                      Navigator.of(context)
                                                          .pushNamed(
                                                        createOrUpdateNoteRoute,
                                                        arguments: [
                                                          note,
                                                          " ${actualDate +
                                                              "    " +
                                                              actualTime}",
                                                          mysize
                                                        ],
                                                      );
                                                    },

                                                  ),


                                                ])
                                            ;
                                          }
                                          else {
                                            return Center(child:

                                            SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: const [
                                                  Image(
                                                    image: AssetImage(
                                                        "assets/images/empty.png"),
                                                    height: 200,
                                                  ),
                                                  SizedBox(height: 15,),
                                                  Text(
                                                    "No Data to fetch! Add Notes to see them here",
                                                    style: TextStyle(

                                                        color: Color(
                                                            0xFFa0acb8),
                                                        fontSize: 13,
                                                        fontFamily: "PoppinsRegular"),
                                                  )
                                                ],
                                              ),
                                            ),);
                                          }
                                        default:
                                          return const CircularProgressIndicator();
                                      }
                                    },
                                  );
                                });



                             }
                           ),





             Positioned(

               child: Align(
                 alignment: Alignment.bottomCenter,
                 child: Container(
                   margin: EdgeInsets.only(bottom: 18),
                   padding: EdgeInsets.all(5),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.all(Radius.circular(40)),
                     color:Color(0xFFFF7D00),
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
                     color: Color(0xFFFF7D00),
                     borderRadius: BorderRadius.circular(40),
                     elevation: 10,
                     child: IconButton(


                         iconSize: 50,
                         alignment: Alignment.center,
                             onPressed:()  {
                           double mysize = original['fontSize'];

                                controller.stream.listen(
                                       (event) { mysize = event['fontSize'];}
                               );
                               var now = DateTime.now();
                               var formatterDate = DateFormat('dd/MM/yy');
                               var formatterTime = DateFormat('kk:mm');
                               String actualDate = formatterDate.format(now);
                               String actualTime = formatterTime.format(now);

                               Navigator.of(context).pushNamed(
                                 createOrUpdateNoteRoute,
                                 arguments: [null, " ${actualDate +"    "+ actualTime} " , mysize],
                               );

                           },
                           icon: Icon(Icons.add,color: Colors.white,),
                       ),


                   ),
                 ),
               ),
             )
               ]),
                  ),
                )




              ],
            )
      ));
  }
}
