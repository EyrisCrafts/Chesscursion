import 'dart:developer';

import 'package:chesscursion_creator/models/model_community_level.dart';
import 'package:chesscursion_creator/providers/prov_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class IServiceApiManager {
  Future<List<ModelCommunityLevel>?> loadCommunityLevels();
  Future<bool> writeCommunityLevel(ModelCommunityLevel level);
  Future<bool> login();
  bool isLoggedIn();
  String generateId();
  String getUserId();
  Future<bool> upvoteCommunityLevel(String levelId, String documentId);
  Future<List<String>> getUserLevelsUpvoted();
}

class ServiceApiManager extends IServiceApiManager {
  @override
  Future<List<ModelCommunityLevel>?> loadCommunityLevels() async {
    // Read all docs. Convert to ModelCommunityLevel. Return list.
    List<ModelCommunityLevel> levels = [];
    try {
      final querySnap = await FirebaseFirestore.instance.collection('community_levels').orderBy("number", descending: true).limit(1).get();
      for (var element in querySnap.docs) {
        levels.addAll(element.data()['levels'].map<ModelCommunityLevel>((e) => ModelCommunityLevel.fromMap(e)).toList());
      }
    } catch (e) {
      return null;
    }
    levels.sort((a, b) => b.upVotes.compareTo(a.upVotes));
    // log(levels.first.toString());
    return levels;
  }

  @override
  Future<bool> writeCommunityLevel(ModelCommunityLevel level) async {
    // Read all docs in community_levels.
    final querySnap = await FirebaseFirestore.instance.collection('community_levels').get();
    // Find the highest number
    int highestNumber = 0;
    for (var element in querySnap.docs) {
      final int? number = element.data()['number'];
      if (number != null && number > highestNumber) {
        highestNumber = number;
      }
    }

    // Get the list of community Levels
    final docSnap = querySnap.docs.where((docSnap) => docSnap.data()['number'] == highestNumber);

    String docId = '';

    if (docSnap.isEmpty) {
      // Create new document
      docId = FirebaseFirestore.instance.collection('community_levels').doc().id;
      level.documentId = docId;
      final toSave = level.toMap();
      log(" toSave: $toSave");
      await FirebaseFirestore.instance.collection("community_levels").doc(docId).set({
        "levels": [toSave],
        "number": highestNumber,
      });
    } else {
      docId = docSnap.first.id;
      level.documentId = docId;
      List<ModelCommunityLevel> levels = docSnap.first.data()['levels'].map<ModelCommunityLevel>((e) => ModelCommunityLevel.fromMap(e)).toList();
      if (levels.length < 500) {
        docId = FirebaseFirestore.instance.collection('community_levels').doc().id;
        levels.add(level);
        try {
          await FirebaseFirestore.instance.collection("community_levels").doc(docId).set({
            "levels": levels.map((e) => e.toMap()).toList(),
          });
        } catch (e) {
          final uid = FirebaseAuth.instance.currentUser!.uid;
          FirebaseFirestore.instance.collection("users").doc(uid).set({"id": uid, "error": "Crossed 200 levels"});
        }
      } else {
        // Create new Document
        docId = FirebaseFirestore.instance.collection('community_levels').doc().id;
        level.documentId = docId;
        await FirebaseFirestore.instance.collection("community_levels").doc(docId).set({
          "levels": [level.toMap()],
          "number": highestNumber + 1,
        });
      }
    }

    return Future.value(true);
  }

  @override
  Future<bool> login() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await gUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, s) {
      print(" Error: $e StackTrace: $s");
      return false;
    }
    return true;
  }

  @override
  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  String generateId() {
    return FirebaseFirestore.instance.collection('community_levels').doc().id;
  }

  @override
  String getUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? "";
  }

  @override
  Future<bool> upvoteCommunityLevel(String levelId, String documentId) async {
    try {
      // check if already upvoted
      final levelsUpvoted = await GetIt.I<ProvUser>().getLevelsUpvoted();
      if (levelsUpvoted.contains(levelId)) {
        return false;
      }

      // Read all docs in community_levels.
      final docSnap = await FirebaseFirestore.instance.collection('community_levels').doc(documentId).get();
      // Find the level
      final List<ModelCommunityLevel> levels = docSnap.data()?['levels'].map<ModelCommunityLevel>((e) => ModelCommunityLevel.fromMap(e)).toList();
      final ModelCommunityLevel level = levels.firstWhere((element) => element.id == levelId);
      level.upVotes++;
      await FirebaseFirestore.instance.collection('community_levels').doc(documentId).update({
        "levels": levels.map((e) => e.toMap()).toList(),
      });
      
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "upvoted": FieldValue.arrayUnion([levelId]),
        "id": uid
      });
    } catch (e) {
      log("Error: $e");
      return false;
    }
    return true;
  }

  @override
  Future<List<String>> getUserLevelsUpvoted() async {
    if (isLoggedIn()) {
      try {
        final docSnap = await FirebaseFirestore.instance.collection('users').doc(getUserId()).get();
        return List<String>.from(docSnap.data()?['upvoted'] ?? []);
      } catch (e) {
        return [];
      }
    }
    return [];
  }
}
