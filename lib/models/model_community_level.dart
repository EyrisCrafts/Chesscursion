// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ModelCommunityLevel {
  String documentId;
  String id;
  String title;
  String createdById;
  String createdByName;
  DateTime createdOn;
  List<List<List<int>>> board;
  int upVotes;

  ModelCommunityLevel({
    required this.documentId,
    required this.id,
    required this.title,
    required this.createdById,
    required this.createdByName,
    required this.createdOn,
    required this.board,
    required this.upVotes,
  });

  ModelCommunityLevel copyWith({
    String? id,
    String? documentId,
    String? title,
    String? createdById,
    String? createdByName,
    int? upVotes,
    DateTime? createdOn,
    List<List<List<int>>>? board,
  }) {
    return ModelCommunityLevel(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      title: title ?? this.title,
      upVotes: upVotes ?? this.upVotes,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      createdOn: createdOn ?? this.createdOn,
      board: board ?? this.board,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'documentId': documentId,
      'title': title,
      'upVotes': upVotes,
      'createdById': createdById,
      'createdByName': createdByName,
      'createdOn': createdOn.millisecondsSinceEpoch,
      'board': toMapForBoard(board)
    };
  }

  Map<String, int> toMapForBoard(List<List<List<int>>> board) {
    Map<String, int> resultMap = {};

    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[i].length; j++) {
        for (int k = 0; k < board[i][j].length; k++) {
          String key = '$i-$j-$k';
          resultMap[key] = board[i][j][k];
        }
      }
    }

    return resultMap;
  }

  factory ModelCommunityLevel.fromMap(Map<String, dynamic> map) {
    return ModelCommunityLevel(
        id: (map['id'] ?? '') as String,
        documentId: (map['documentId'] ?? '') as String,
        title: (map['title'] ?? '') as String,
        upVotes: (map['upVotes'] ?? 0) as int,
        createdById: (map['createdById'] ?? '') as String,
        createdByName: (map['createdByName'] ?? '') as String,
        createdOn: DateTime.fromMillisecondsSinceEpoch((map['createdOn'] ?? 0) as int),
        board: fromMapForBoard(map['board']));
  }

  static List<List<List<int>>> fromMapForBoard(Map<String, dynamic> map) {
    // Determine the dimensions from the map
    int maxX = 0;
    int maxY = 0;
    int maxZ = 0;

    for (String key in map.keys) {
      List<String> parts = key.split('-');
      int x = int.parse(parts[0]);
      int y = int.parse(parts[1]);
      int z = int.parse(parts[2]);

      if (x > maxX) maxX = x;
      if (y > maxY) maxY = y;
      if (z > maxZ) maxZ = z;
    }

    // Initialize the 3D list with default values (0)
    List<List<List<int>>> board = List.generate(maxX + 1, (i) => List.generate(maxY + 1, (j) => List.generate(maxZ + 1, (k) => 0)));

    // Fill in the values from the map
    for (String key in map.keys) {
      List<String> parts = key.split('-');
      int x = int.parse(parts[0]);
      int y = int.parse(parts[1]);
      int z = int.parse(parts[2]);

      board[x][y][z] = map[key]!;
    }

    return board;
  }

  String toJson() => json.encode(toMap());

  factory ModelCommunityLevel.fromJson(String source) => ModelCommunityLevel.fromMap(json.decode(source) as Map<String, dynamic>);


  @override
  bool operator ==(covariant ModelCommunityLevel other) {
    if (identical(this, other)) return true;

    return other.title == title && other.createdById == createdById && other.createdByName == createdByName && other.createdOn == createdOn && listEquals(other.board, board);
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ createdById.hashCode ^ createdByName.hashCode ^ createdOn.hashCode ^ board.hashCode;
  }

  @override
  String toString() {
    return 'ModelCommunityLevel(documentId: $documentId, id: $id, title: $title, createdById: $createdById, createdByName: $createdByName, createdOn: $createdOn, board: $board, upVotes: $upVotes)';
  }
}
