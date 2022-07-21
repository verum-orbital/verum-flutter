import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String caption;
  final DateTime creationDate;
  final String mediaURL;
  final String postId;
  final likes;

  const Post(
      {required this.uid,
      required this.caption,
      required this.creationDate,
      required this.mediaURL,
      required this.postId,
      required this.likes});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'caption': caption,
        'creationDate': creationDate,
        'mediaURL': mediaURL,
        'postId': postId,
        'likes': likes,
      };

  static Post fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Post(
      uid: data['uid'],
      caption: data['caption'],
      creationDate: data['creationDate'],
      mediaURL: data['mediaURL'],
      postId: data['postId'],
      likes: data['likes'],
    );
  }

  static Post fromQuerySnapshot(QueryDocumentSnapshot snapshot, String uid) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Post(
      uid: data['uid'],
      caption: data['caption'],
      creationDate: (data['creationDate'] as Timestamp).toDate(),
      mediaURL: data['mediaURL'],
      postId: data['postId'],
      likes: data['likes'],
    );
  }
}
