//enum for different room type
enum RoomType { vip, private, general, icu }

enum BedStatus { busy, free }

//class for each bed
class Bed {
  final String bedNumber;
  BedStatus status;
  final Room room;
  Bed({required this.bedNumber, this.status = BedStatus.free, required this.room});

  //toString method for bed
  @override
  String toString() {
    return '''
    Bed number: $bedNumber
    Current status: ${status.name}
  ''';
  }

  //function to check if the bed is free
  bool ifBedFree() => status == BedStatus.free;

  //free the bed
  void freeBed() => status = BedStatus.free;

  //assign bed
  void assignBed() => status = BedStatus.busy;
}

class Room {
  final String roomNumber;
  final int capacity;
  final List<Bed> beds = [];
  final RoomType type;

  //default room set to general room
  Room({required this.roomNumber, required this.capacity}) : type = RoomType.general;
  Room.private({required this.roomNumber}) : capacity = 1, type = RoomType.private;
  Room.icu({required this.roomNumber}) : capacity = 1, type = RoomType.icu;
  Room.vip({required this.roomNumber}) : capacity = 1, type = RoomType.vip;

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
    print('Room type: ${type.name}');
    print('Room capacity: $capacity');
    print('----- Total bed -----');
    for (var bed in beds) {
      print(bed);
    }
  }
}
