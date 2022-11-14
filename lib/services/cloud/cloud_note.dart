import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nibret_kifel/constants/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final String title;
  final String dateModified;
  final String firstName;
  final String lastName;

   CloudNote( {
    required this.documentId,
    required this.ownerUserId,
    required this.text,
     required this.title,
     required this.dateModified,
     required this.firstName,
     required this.lastName,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String,
        title = snapshot.data()[titleFieldName] as String ,
        dateModified = snapshot.data()[lastDateModfiedFieldName] as String,
         firstName = snapshot.data()[firstNameFieldName] as String ,
        lastName = snapshot.data()[lastNameFieldName] as String ;
}