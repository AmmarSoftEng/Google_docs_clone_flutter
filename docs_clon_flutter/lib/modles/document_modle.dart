import 'dart:convert';

import 'dart:convert';

class DocumentModel {
  final String title;
  final String uid;
  final List content;
  final DateTime createdAt;
  final String id;
  DocumentModel({
    required this.title,
    required this.uid,
    required this.content,
    required this.createdAt,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'uid': uid,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'id': id,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      title: map['title'] ?? '',
      uid: map['uid'] ?? '',
      content: List.from(map['content']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      id: map['_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) => DocumentModel.fromMap(json.decode(source));
}
// ignore_for_file: public_member_api_docs, sort_constructors_first
// class DocumentModle {
//   String title;
//   String uid;
//   String content;
//   DateTime createdAt;
//   String id;
//   DocumentModle({
//     required this.title,
//     required this.uid,
//     required this.content,
//     required this.createdAt,
//     required this.id,
//   });

//   DocumentModle copyWith({
//     String? title,
//     String? uid,
//     String? content,
//     DateTime? createdAt,
//     String? id,
//   }) {
//     return DocumentModle(
//       title: title ?? this.title,
//       uid: uid ?? this.uid,
//       content: content ?? this.content,
//       createdAt: createdAt ?? this.createdAt,
//       id: id ?? this.id,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'title': title,
//       'uid': uid,
//       'content': content,
//       'createdAt': createdAt.millisecondsSinceEpoch,
//       'id': id,
//     };
//   }

//   factory DocumentModle.fromMap(Map<String, dynamic> map) {
//     return DocumentModle(
//       title: map['title'] as String,
//       uid: map['uid'] as String,
//       content: map['content'] as String,
//       createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
//       id: map['id'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory DocumentModle.fromJson(String source) => DocumentModle.fromMap(json.decode(source) as Map<String, dynamic>);
// }
