import 'package:uuid/uuid.dart';

//class for patients
enum gender { MALE, FEMALE }

class Patient {
  final String _id = const Uuid().v4(); //set uuid for pricvate fied (ai generated)
  final String _firstName;
  final String _lastName;
  final String _gender;
  final String _contact;
  final DateTime createdAt;

  Patient({required String firstName, required String lastName, required String gender, required String contact})
    : _firstName = firstName,
      _lastName = lastName,
      _gender = gender,
      _contact = contact,
      createdAt = DateTime.now();

  //getter for patient
  String get id => _id;
  String get fullName => '$_firstName $_lastName';
  String get gender => _gender;
  String get contact => _contact;

  //toString method
  @override
  String toString(){
    return '''
    Id: $id
    Full name: $fullName
    Gender: $gender
    Contact: $contact
    ''';
  }

}
