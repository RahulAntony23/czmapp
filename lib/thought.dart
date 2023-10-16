class thought {
  int tid;
  int uid;
  String heading;
  String description;
  int likes;
  bool isLiked = false;

  thought(
      {required this.tid,
      required this.uid,
      required this.heading,
      required this.description,
      required this.likes,
      required this.isLiked});
}
