import 'package:uuid/uuid.dart';

//class for patients
enum Gender { male, female }

class Patient {
  final String _id = const Uuid()
      .v4(); //set uuid for pricvate fied (ai generated)
  final String _firstName;
  final String _lastName;
  final Gender _gender;
  final String _contact;
  final DateTime createdAt;

  Patient({
    required String firstName,
    required String lastName,
    required Gender gender,
    required String contact,
  }) : _firstName = firstName,
       _lastName = lastName,
       _gender = gender,
       _contact = contact,
       createdAt = DateTime.now();

  // Private named constructor for deserialization
  //AI Generated
  Patient._fromJson({
    required String id,
    required String firstName,
    required String lastName,
    required Gender gender,
    required String contact,
    required this.createdAt,
  }) : _firstName = firstName,
       _lastName = lastName,
       _gender = gender,
       _contact = contact;
  //getter for patient
  String get id => _id;
  String get fullName => '$_firstName $_lastName';
  Gender get gender => _gender;
  String get contact => _contact;

  //toString method
  @override
  String toString() {
    return '''
    Id: $id
    Full name: $fullName
    Gender: ${gender.name}
    Contact: $contact
    ''';
  }

  // Convert patient to JSON
  Map<String, String> toJson() => {
    'id': id,
    'firstName': _firstName,
    'lastName': _lastName,
    'gender': gender.name,
    'contact': contact,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Patient.fromJson(Map<String, String> json) => Patient._fromJson(
    id: json['id']!,
    firstName: json['firstName']!,
    lastName: json['lastName']!,
    gender: Gender.values.firstWhere((g) => g.name == json['gender']),
    contact: json['contact']!,
    createdAt: DateTime.parse(json['createdAt']!),
  );
}
