//return a formatted data as a string

import 'package:cloud_firestore/cloud_firestore.dart';

String FormatDate(Timestamp timestamp) {
  // Timestamp is the object we retrive from firebse
  //so to display it, lets convert it to a string
  DateTime dateTime = timestamp.toDate();

  //get year
  String year = dateTime.year.toString();

  //get month
  String month = dateTime.day.toString();

  //get day
  String day = dateTime.day.toString();

  //final formatted date
  String formattedDate = '$day/$month/$year';
  return formattedDate;
}
