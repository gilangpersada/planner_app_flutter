import 'package:cloud_firestore/cloud_firestore.dart';

class Api {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;
  CollectionReference ref;

  Api(this.path) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDataCollection() {
    return ref.get();
  }

  Future<QuerySnapshot> getNestedDataCollection(String id, String path) {
    return ref.doc(id).collection(path).get();
  }

  Future<QuerySnapshot> getNestedNestedDataCollection(
      String id, String idNested, String path) {
    return ref.doc(id).collection(path).doc(idNested).collection(path).get();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamWhereDataCollection(
      String property, String propertyValue) {
    return ref.where(property, isEqualTo: propertyValue).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamWhereArrayDataCollection(
      String property, String propertyValue) {
    return ref.where(property, arrayContains: propertyValue).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamWhereOrderedDataCollection(
      String property, String propertyValue, String orderBy) {
    return ref
        .where(property, isEqualTo: propertyValue)
        .orderBy(orderBy, descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> streamNestedDataCollection(String id, String path) {
    return ref.doc(id).collection(path).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentById(String id) {
    return ref.doc(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.doc(id).delete();
  }

  Future<void> removeNestedDocument(String id, String idNest, String path) {
    return ref.doc(id).collection(path).doc(idNest).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  Future<void> setDocument(Map data, String id) {
    return ref.doc(id).set(data);
  }

  Future<void> addProjectMember(String idProject, Map data, String idUser) {
    return ref.doc(idProject).collection('members').doc(idUser).set(data);
  }

  Future<void> addAssignee(Map data, String idTask) {
    return ref.doc(idTask).update(data);
  }

  Future<DocumentReference> addProjectBoard(String idProject, Map data) {
    return ref.doc(idProject).collection('boards').add(data);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String idUser) {
    return ref.doc(idUser).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserByEmail(String input) {
    return ref.where('email', isGreaterThanOrEqualTo: input).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getWhereDataCollection(
      String property, String propertyValue) {
    return ref.where(property, isEqualTo: propertyValue).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getWhereArrayDataCollection(
      String property, String propertyValue) {
    return ref.where(property, arrayContains: propertyValue).get();
  }

  Future<QuerySnapshot> getUserByUsername(String input) {
    return ref.where('username', isEqualTo: input).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getSharedMember(
      String idUser) {
    return ref.doc(idUser).get();
  }

  Future<QuerySnapshot> getProjectMember(String idProject) {
    return ref.doc(idProject).collection('members').get();
  }

  Future<QuerySnapshot> getTaskBoard(String idBoard) {
    return ref.where('idBoard', isEqualTo: idBoard).get();
  }

  Future<QuerySnapshot> getTaskPersonal(String idUser) {
    return ref.where('assignee', arrayContains: idUser).get();
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.doc(id).update(data);
  }

  Future<void> updateNestedDocument(
      Map data, String id, String idNest, String path) {
    return ref.doc(id).collection(path).doc(idNest).update(data);
  }

  Future<void> setIsDone(String idTask, String idTodo, String path, Map data) {
    return ref.doc(idTask).collection(path).doc(idTodo).update(data);
  }
}
