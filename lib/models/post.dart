import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/place.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final likes;
  final PlaceLocation? location;

  const Post(
      {required this.description,
      required this.uid,
      required this.username,
      required this.likes,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profImage,
      required this.location,
      });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot["description"],
      uid: snapshot["uid"],
      likes: snapshot["likes"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      username: snapshot["username"],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      location: snapshot['location'] != null
          ? PlaceLocation(
              latitude: snapshot['location']['latitude'],
              longitude: snapshot['location']['longitude'],
              address: snapshot['location']['address'],
            )
          : null,
    );
  }

   Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'location': location != null
            ? {
                'latitude': location!.latitude,
                'longitude': location!.longitude,
                'address': location!.address,
              }
            : null,
      };
}