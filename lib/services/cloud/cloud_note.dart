import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Notes_App/constants/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String jsonText;
  final String plainText;
  final String title;
  final String dateModified;
  final String firstName;
  final String lastName;

  CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.plainText,
    required this.jsonText,
    required this.title,
    required this.dateModified,
    required this.firstName,
    required this.lastName,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        jsonText = snapshot.data()[jsonTextFieldName] as String,
        plainText = snapshot.data()[plainTextFieldName] as String,
        title = snapshot.data()[titleFieldName] as String,
        dateModified = snapshot.data()[lastDateModfiedFieldName] as String,
        firstName = snapshot.data()[firstNameFieldName] as String,
        lastName = snapshot.data()[lastNameFieldName] as String;
}
