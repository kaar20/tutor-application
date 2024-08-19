class Profile {
  final String uid;
  final bool type;
  final String fullName;
  final String phoneNumber;
  final String bio;
  final String address;
  final String education;
  final String extraInfo;
  final String image;
  final String exam;
  final List<dynamic> subject;
  final double price;

  Profile({
  required  this.uid,
    required this.type,
  required  this.fullName,
    required this.phoneNumber,
   required this.bio,
  required  this.address,
   required this.education,
    required this.extraInfo,
    required this.image,
   required this.exam,
   required this.subject,
  required  this.price,
  });

  String toString() {
    return uid +
        type.toString() +
        fullName +
        phoneNumber +
        bio +
        address +
        education +
        extraInfo +
        image;
  }
}
