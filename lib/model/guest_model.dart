enum RSVPStatus { attending, notAttending, pending }

class Guest {
  String id;
  String name;
  String? phoneNumber;
  String? email;
  RSVPStatus status;
  DateTime addedDate;

  Guest({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    required this.status,
    required this.addedDate,
  });
}
