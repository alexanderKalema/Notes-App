import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nibret_kifel/services/auth/bloc/auth_event.dart';
import 'package:nibret_kifel/services/cloud/cloud_note.dart';
import 'package:nibret_kifel/constants/cloud_storage_constants.dart';
import 'package:nibret_kifel/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {

  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({required String documentId}) async {
    try {

      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
    required String title,
    required String date,
  }) async {
    try {

      await notes.doc(documentId).update({textFieldName: text, lastDateModfiedFieldName: date, titleFieldName:title});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId, required String searchedText}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where(  (note)   {


            if(searchedText.isEmpty){
              return (note.ownerUserId == ownerUserId) ;
            }
            else if(searchedText.isNotEmpty){

              return (note.ownerUserId == ownerUserId &&(
                  note.text.toLowerCase().contains(searchedText.toLowerCase()) ||
                      note.text.toUpperCase().contains(searchedText.toUpperCase()) ||
                      note.title.toLowerCase().contains(searchedText.toLowerCase()) ||
                      note.title.toUpperCase().contains(searchedText.toUpperCase())

              ));
            }
            else{return(note.ownerUserId == ownerUserId);}

          }));

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId, required String firstName, required String lastName}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
      titleFieldName:'',
      lastDateModfiedFieldName:'',
      firstNameFieldName : firstName,
      lastNameFieldName:lastName

    });
    final fetchedNote = await document.get();
    return CloudNote(
      firstName: '',
      lastName: '',
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
      title: '',
      dateModified: ''
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;
}
