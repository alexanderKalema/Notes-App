import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Notes_App/services/bloc/auth_bloc/auth_event.dart';
import 'package:Notes_App/services/cloud/cloud_note.dart';
import 'package:Notes_App/constants/cloud_storage_constants.dart';
import 'package:Notes_App/services/cloud/cloud_storage_exceptions.dart';

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
    required String plainText,
    required String jsonText,
    required String title,
    required String date,
  }) async {
    try {
      await notes.doc(documentId).update({
        plainTextFieldName: plainText,
        jsonTextFieldName: jsonText,
        lastDateModfiedFieldName: date,
        titleFieldName: title
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes(
          {required String ownerUserId, required String searchedText}) =>
      notes.snapshots().map((event) =>
          event.docs.map((doc) => CloudNote.fromSnapshot(doc)).where((note) {
            if (searchedText.isNotEmpty) {
              return (note.ownerUserId == ownerUserId &&
                  (note.plainText
                          .toLowerCase()
                          .contains(searchedText.toLowerCase()) ||
                      note.plainText
                          .toUpperCase()
                          .contains(searchedText.toUpperCase()) ||
                      note.title
                          .toLowerCase()
                          .contains(searchedText.toLowerCase()) ||
                      note.title
                          .toUpperCase()
                          .contains(searchedText.toUpperCase())));
            } else {
              return (note.ownerUserId == ownerUserId);
            }
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

  Future<CloudNote> createNewNote(
      {required String ownerUserId,
      required String firstName,
      required String lastName}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      plainTextFieldName: '',
      jsonTextFieldName: '',
      titleFieldName: '',
      lastDateModfiedFieldName: '',
      firstNameFieldName: firstName,
      lastNameFieldName: lastName
    });
    final fetchedNote = await document.get();
    return CloudNote(
        firstName: '',
        lastName: '',
        documentId: fetchedNote.id,
        ownerUserId: ownerUserId,
        plainText: '',
        jsonText: '',
        title: '',
        dateModified: '');
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;
}
