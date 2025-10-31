//enum for different room type
enum roomType { VIP, PRIVATE, GENERAL, ICU }

enum bedStatus { BUSY, FREE }

//class for each bed
class Bed {
  final String bedNumber;
  bedStatus status;
  final Room room;
  Bed({required this.bedNumber, this.status = bedStatus.FREE, required this.room});

  //toString method for bed
  @override
  String toString() {
    return '''
    Bed number: $bedNumber
    Current status: $status
  ''';
  }

  //function to check if the bed is free
  bool ifBedFree() => status == bedStatus.FREE;

  //free the bed
  void freeBed() => status = bedStatus.FREE;
}

class Room {
  final String roomNumber;
  final int capacity;
  final List<Bed> beds = [];
  final roomType type;

  //default room set to general room
  Room({required this.roomNumber, required this.capacity}) : type = roomType.GENERAL;
  Room.private({required this.roomNumber}) : capacity = 1, type = roomType.PRIVATE;
  Room.icu({required this.roomNumber}) : capacity = 1, type = roomType.ICU;
  Room.vip({required this.roomNumber}) : capacity = 1, type = roomType.VIP;

  //function to add bed
  void addBed(Bed bed) {
    beds.add(bed);
  }

  //function to remove bed
  bool removeBed(String bedNumber) {
    int totalBed = beds.length;
    beds.removeWhere((bed) => bed.bedNumber == bedNumber);

    return totalBed < beds.length; //return true of bed lenght decrease
  }

  //show all bed by room number
  void roomDetail() {
    print('-----Room detail-----');
    print('Room number: $roomNumber');
    print('Room type: $type');
    print('Room capacity: $capacity');
    print('----- Total bed -----');
    for (var bed in beds) {
      print(bed);
    }
  }
}
