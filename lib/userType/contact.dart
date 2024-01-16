class Contact {
  String id;
  String photoUrl; //the path of image source
  String name;
  String mobile;
  String email;
  int isFav;

  Contact({
    required this.id,
    required this.photoUrl,
    required this.name,
    required this.mobile,
    required this.email,
    required this.isFav,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photo': photoUrl,
      'name': name,
      'mobile': mobile,
      'email': email,
      'isfav': isFav,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      photoUrl: map['photo'],
      name: map['name'],
      mobile: map['mobile'],
      email: map['email'],
      isFav: map['isfav'],
    );
  }
}
