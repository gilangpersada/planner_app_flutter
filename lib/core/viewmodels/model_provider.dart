import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:party_planner/core/models/category.dart';
import 'package:party_planner/core/models/shared.dart';
import 'package:party_planner/core/models/task.dart';
import 'package:party_planner/core/models/user.dart';
import 'package:party_planner/core/services/firebase_api.dart';

class ModelProvider extends ChangeNotifier {
  List<Task> tasks = [];
  List<Category> categories = [];
  List<Shared> shared = [];
  User authUser;
  final Api apiTask = Api('tasks');
  final Api apiCategory = Api('category');
  final Api apiShared = Api('shared');
  final Api apiUser = Api('users');
  final Api apiChat = Api('chats');
  final Api apiNotif = Api('notifs');

  List<Task> get getTasks {
    return [...tasks];
  }

  User get getCurrentUser {
    return authUser;
  }

  List<Category> get getCategories {
    return [...categories];
  }

  List<Shared> get getShared {
    return [...shared];
  }

  void setListTask(List<Task> taskData) {
    tasks = taskData;
  }

  Future<int> countTaskCategory(String idCategory, String authUser) async {
    var taskSnapshot =
        await apiTask.getWhereDataCollection('created_by', authUser);
    var taskData = taskSnapshot.docs.where((task) {
      return task.data()['category'] == idCategory;
    }).toList();

    notifyListeners();

    return taskData.length;
  }

  Future<int> countTaskDone() async {
    List taskAll = [];
    for (var category in categories) {
      var taskSnapshotCategory =
          await apiTask.getWhereDataCollection('category', category.id);
      taskSnapshotCategory.docs.map((e) {
        if (e.data()['created_by'] == authUser.id) {
          taskAll.add(e.data());
        }
      }).toList();
    }
    for (var share in shared) {
      var taskSnapshotShared =
          await apiTask.getWhereDataCollection('shared', share.id);
      taskSnapshotShared.docs.map((e) {
        if (e.data()['created_by'] == authUser.id) {
          taskAll.add(e.data());
        }
      });
    }

    // var taskCat =
    //     taskCategory.where((task) => task.data()['isDone'] == true).toList();
    // var taskShar =
    //     taskShared.where((task) => task.data()['isDone'] == true).toList();
    var taskCount = taskAll.where((task) => task['isDone'] == true).toList();

    return taskCount.length;
  }

  Future<int> countTaskNotDone() async {
    List taskAll = [];
    for (var category in categories) {
      var taskSnapshotCategory =
          await apiTask.getWhereDataCollection('category', category.id);

      taskSnapshotCategory.docs.map((e) {
        if (e.data()['created_by'] == authUser.id) {
          taskAll.add(e.data());
        }
      }).toList();
    }
    for (var share in shared) {
      var taskSnapshotShared =
          await apiTask.getWhereDataCollection('shared', share.id);

      taskSnapshotShared.docs.map((e) {
        if (e.data()['created_by'] == authUser.id) {
          taskAll.add(e.data());
        }
      });
    }

    // var taskCat =
    //     taskCategory.where((task) => task.data()['isDone'] == true).toList();
    // var taskShar =
    //     taskShared.where((task) => task.data()['isDone'] == true).toList();
    var taskCount = taskAll.where((task) => task['isDone'] == false).toList();

    return taskCount.length;
  }

  Future<int> countTaskShared(String idShared) async {
    var taskSnapshot = await apiTask.getWhereDataCollection('shared', idShared);

    return taskSnapshot.docs.length;
  }

  Category getCategoryById(String idCategory) {
    var category =
        categories.firstWhere((category) => category.id == idCategory);
    return category;
  }

  Shared getSharedById(String idShared) {
    var share = shared.firstWhere((share) => share.id == idShared);
    return share;
  }

  Future<Category> fetchCategoryById(String idCategory) async {
    var categorySnap = await apiCategory.getDocumentById(idCategory);
    var category = Category.fromMap(categorySnap.data(), categorySnap.id);
    return category;
  }

  Future<Shared> fetchSharedById(String idShared) async {
    var sharedSnap = await apiShared.getDocumentById(idShared);

    List<String> userList = sharedSnap.data()['members'].cast<String>();
    List<User> users = [];
    for (var usr in userList) {
      var userSnapshot = await apiUser.getSharedMember(usr);
      users.add(User.fromMap(userSnapshot.data(), userSnapshot.id));
    }
    var shared = Shared.fromMap(sharedSnap.data(), sharedSnap.id, users);
    return shared;
  }

  Future<void> addCategory(Map data) async {
    await apiCategory.addDocument(data);

    return;
  }

  Future<String> addShared(Map data) async {
    var docRef = await apiShared.addDocument(data);
    var idShared = docRef.id;
    return idShared;
  }

  Future<void> addMessage(Map data) async {
    await apiChat.addDocument(data);

    return;
  }

  Future<void> addSharedNotif(Map data, String id) async {
    await apiNotif.setDocument(data, id);

    return;
  }

  Future<void> addTask(Map data) async {
    await apiTask.addDocument(data);

    return;
  }

  Future<void> updateTask(Map data, String idTask) async {
    await apiTask.updateDocument(data, idTask);

    return;
  }

  Future<void> updateDone(Map data, String idTask) async {
    await apiTask.updateDocument(data, idTask);

    return;
  }

  Future<void> deleteCategory(String idCategory) async {
    await apiCategory.removeDocument(idCategory);
    var tasks = await apiTask.getWhereDataCollection('category', idCategory);
    for (var task in tasks.docs) {
      await apiTask.removeDocument(task.id);
    }
    return;
  }

  Future<void> deleteShared(String idShared) async {
    await apiShared.removeDocument(idShared);
    var shareds = await apiTask.getWhereDataCollection('shared', idShared);
    for (var task in shareds.docs) {
      await apiTask.removeDocument(task.id);
    }
    return;
  }

  Future<void> deleteTask(String idTask) async {
    await apiTask.removeDocument(idTask);

    return;
  }

  Future<void> updateCategory(Map data, String idCategory) async {
    await apiCategory.updateDocument(data, idCategory);

    return;
  }

  Future<void> updateShared(Map data, String idShared) async {
    await apiShared.updateDocument(data, idShared);

    return;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamWhereTask(
      String idCategory) {
    return apiTask.streamWhereDataCollection('category', idCategory);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamNotif(String authUser) {
    return apiNotif.streamWhereArrayDataCollection('notifTo', authUser);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAuthTask(String authUser) {
    return apiTask.streamWhereDataCollection('created_by', authUser);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChat(String idShared) {
    return apiChat.streamWhereOrderedDataCollection(
        'shared', idShared, 'sendAt');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamWhereTaskShared(
      String idShared) {
    return apiTask.streamWhereDataCollection('shared', idShared);
  }

  Future<void> fetchCategory(String authUser) async {
    var categorySnapshot =
        await apiCategory.getWhereDataCollection('created_by', authUser);
    var categoryData = categorySnapshot.docs
        .map((category) => Category.fromMap(category.data(), category.id))
        .toList();
    categories = categoryData;
    notifyListeners();
  }

  Future<void> fetchShared(String authUser) async {
    var sharedSnapshot =
        await apiShared.getWhereArrayDataCollection('members', authUser);
    List<Shared> sharedData = [];
    for (var share in sharedSnapshot.docs) {
      List<String> userList = share.data()['members'].cast<String>();
      List<User> users = [];
      for (var usr in userList) {
        var userSnapshot = await apiUser.getSharedMember(usr);
        users.add(User.fromMap(userSnapshot.data(), userSnapshot.id));
      }
      sharedData.add(Shared.fromMap(share.data(), share.id, users));
    }

    shared = sharedData;
    notifyListeners();
  }

  Future<void> fetchTask(bool isShared) async {
    var taskSnapshot = await apiTask.getDataCollection();

    var taskData = taskSnapshot.docs.map((task) {
      Category _category;
      Shared _shared;
      if (isShared) {
        if (task.data()['shared'] != null) {
          _shared = shared.firstWhere(
            (shared) => shared.id == task.data()['shared'],
            orElse: () => null,
          );
        } else {
          _shared = null;
        }
      } else {
        if (task.data()['category'] != null) {
          _category = categories.firstWhere(
            (category) => category.id == task.data()['category'],
            orElse: () => null,
          );
        } else {
          _category = null;
        }
      }

      var map = {
        'task_name': task.data()['task_name'],
        'description': task.data()['description'],
        'deadlineDateTime': task.data()['deadlineDateTime'] == null
            ? null
            : task.data()['deadlineDateTime'].toDate(),
        'priority': task.data()['priority'],
        'onlyDate': task.data()['onlyDate'],
        'onlyTime': task.data()['onlyTime'],
        'useDateTime': task.data()['useDateTime'],
        'isDone': task.data()['isDone'],
      };
      return Task.fromMap(
        map,
        task.id,
        _category,
        _shared,
      );
    }).toList();
    tasks = taskData;

    notifyListeners();
  }

  Future<String> fetchSharedByCode(String code) async {
    var sharedSnap = await apiShared.getWhereDataCollection('code', code);
    var sharedId = sharedSnap.docs[0].id;
    return sharedId;
  }

  Future<void> joinSharedByCode(String idShared, Map data) async {
    await apiShared.updateDocument(data, idShared);
    return;
  }

  Future<void> fetchAllTask() async {
    var taskSnapshot = await apiTask.getDataCollection();

    var taskData = taskSnapshot.docs.map((task) {
      Category _category;
      Shared _shared;

      if (task.data()['shared'] != null) {
        _shared = shared.firstWhere(
          (shared) => shared.id == task.data()['shared'],
          orElse: () => null,
        );
      } else {
        _shared = null;
      }

      if (task.data()['category'] != null) {
        _category = categories.firstWhere(
          (category) => category.id == task.data()['category'],
          orElse: () => null,
        );
      } else {
        _category = null;
      }

      var map = {
        'task_name': task.data()['task_name'],
        'description': task.data()['description'],
        'deadlineDateTime': task.data()['deadlineDateTime'] == null
            ? null
            : task.data()['deadlineDateTime'].toDate(),
        'priority': task.data()['priority'],
        'onlyDate': task.data()['onlyDate'],
        'onlyTime': task.data()['onlyTime'],
        'useDateTime': task.data()['useDateTime'],
        'isDone': task.data()['isDone'],
      };
      return Task.fromMap(
        map,
        task.id,
        _category,
        _shared,
      );
    }).toList();
    tasks = taskData;

    notifyListeners();
  }

  Future<void> fetchTaskShared(String idShared) async {
    var taskSnapshot = await apiTask.getWhereDataCollection('shared', idShared);

    var taskData = taskSnapshot.docs.map((task) {
      Category _category;
      Shared _shared;

      if (task.data()['shared'] != null && task.data() != null) {
        _shared =
            shared.firstWhere((shared) => shared.id == task.data()['shared']);
      } else {
        _shared = null;
      }

      var map = {
        'task_name': task.data()['task_name'],
        'description': task.data()['description'],
        'deadlineDateTime': task.data()['deadlineDateTime'] == null
            ? null
            : task.data()['deadlineDateTime'].toDate(),
        'priority': task.data()['priority'],
        'onlyDate': task.data()['onlyDate'],
        'onlyTime': task.data()['onlyTime'],
        'useDateTime': task.data()['useDateTime'],
        'isDone': task.data()['isDone'],
      };
      return Task.fromMap(
        map,
        task.id,
        _category,
        _shared,
      );
    }).toList();
    tasks = taskData;

    notifyListeners();
  }

  Future<List<User>> getUserByEmail(String email) async {
    var userSnapshot = await apiUser.getUserByEmail(email);
    var userData = userSnapshot.docs
        .map((user) => User.fromMap(user.data(), user.id))
        .toList();

    return userData;
  }

  Future<User> getAuthUser(String idUser) async {
    var userSnapshot = await apiUser.getUser(idUser);
    var userData = User.fromMap(userSnapshot.data(), userSnapshot.id);

    return userData;
  }

  Future<void> loginUser(String idUser) async {
    var userSnapshot = await apiUser.getUser(idUser);
    var userData = User.fromMap(userSnapshot.data(), userSnapshot.id);
    authUser = userData;
    notifyListeners();
    return;
  }

  void logoutUser() {
    authUser = null;
    categories = null;
    shared = null;
    tasks = null;
    notifyListeners();
  }
}
