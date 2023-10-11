class thought {
  int tid;
  int uid;
  String heading;
  String description;

  thought(
      {required this.tid,
      required this.uid,
      required this.heading,
      required this.description});

  static thought fromJson(json) => thought(
      tid: json['tid'],
      uid: json['uid'],
      heading: json['heading'],
      description: json['description']);
}
