import 'package:bikesetupapp/bike_enums/biketype.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bikesetupapp/bike_enums/category.dart';

class DatabaseService {
  DatabaseService(this.userID);
  String userID;

  final CollectionReference userbikesetup =
      FirebaseFirestore.instance.collection('UserBikeSetup');

  Future createBike(String bikename, Map<String, String> setupinformation,
      String biketype, bool isdefaultbike) async {
    await createSetup(bikename, 'Default', setupinformation);

    if (isdefaultbike) {
      await setDefaultBike(bikename);
    }
    await createTodoList(bikename);
    return await userbikesetup
        .doc(userID)
        .collection('UserData')
        .doc('BikeList')
        .set({bikename: biketype}, SetOptions(merge: true));
  }

  Future createSetup(
    String bikename,
    String setupname,
    Map<String, String> setupinformation,
  ) async {
    await createFork(bikename, setupname);
    await createShock(bikename, setupname);
    await createFrontTire(bikename, setupname);
    await createRearTire(bikename, setupname);
    await createGeneralSettings(bikename, setupname);
    await createSetupList(bikename, setupname, setupinformation);
  }

  Future createFork(String bikename, String setupname) async {
    return await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(bikename)
        .collection(setupname)
        .doc(Category.fork.category)
        .set({
      'Pressure': '90',
    }, SetOptions(merge: true));
  }

  Future createShock(String bikename, String setupname) async {
    return await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(bikename)
        .collection(setupname)
        .doc(Category.shock.category)
        .set({'Pressure': '180'}, SetOptions(merge: true));
  }

  Future createFrontTire(String bikename, String setupname) async {
    return await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(bikename)
        .collection(setupname)
        .doc(Category.fronttire.category)
        .set({'Pressure': '24'}, SetOptions(merge: true));
  }

  Future createRearTire(String bikename, String setupname) async {
    return await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(bikename)
        .collection(setupname)
        .doc(Category.reartire.category)
        .set({'Pressure': '26'}, SetOptions(merge: true));
  }

  Future createGeneralSettings(String bikename, String setupname) async {
    return await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(bikename)
        .collection(setupname)
        .doc(Category.generalsettings.category)
        .set({'Reach': '450mm', 'Stackhight': '20mm', 'Seathight': '35mm'},
            SetOptions(merge: true));
  }

  Future createSetupList(String bikename, String setupname,
      Map<String, dynamic> suspension) async {
    return await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(bikename)
        .set({setupname: suspension}, SetOptions(merge: true));
  }

  Future createTodoList(String bikename) async {
    return await userbikesetup
        .doc(userID)
        .collection('ToDoList')
        .doc(bikename)
        .collection('MyList')
        .doc()
        .set({
      'taskname': 'My First Task',
      'taskdescription': 'This is my first task',
      'Part': 'Breaks',
      'done': false,
      'created': DateTime.now()
    }, SetOptions(merge: true));
  }

  //set functions
  Future setDefaultBike(String bikename) async {
    return await userbikesetup
        .doc(userID)
        .collection('UserData')
        .doc('DefaultBike')
        .set({'default': bikename}, SetOptions(merge: true));
  }

  Future setSetting(String key, String value, String bikename, String category,
      String setup) async {
    return await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(bikename)
        .collection(setup)
        .doc(category)
        .set({key: value}, SetOptions(merge: true));
  }

  Future editSetting(String key, String value, String bikename, String category,
      String setup) async {
    return await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(bikename)
        .collection(setup)
        .doc(category)
        .update({key: value});
  }

  Future setTodo(String bikename, String taskname, String taskdescription, String part) async {
    return await userbikesetup
        .doc(userID)
        .collection('ToDoList')
        .doc(bikename)
        .collection('MyList')
        .doc()
        .set({
      'taskname': taskname,
      'taskdescription': taskdescription,
      'Part': part,
      'done': false,
      'created': DateTime.now()
    }, SetOptions(merge: true));
  }

  Future editTodo(String bikename, String docID, String taskname, String taskdescription, String part, bool isdone) async {
    return await userbikesetup
        .doc(userID)
        .collection('ToDoList')
        .doc(bikename)
        .collection('MyList')
        .doc(docID)
        .set({
      'taskname': taskname,
      'taskdescription': taskdescription,
      'Part': part,
      'done': isdone,
    }, SetOptions(merge: true));
  }

  Future deleteTodo(String bikename, String todoid) async {
    return await userbikesetup
        .doc(userID)
        .collection('ToDoList')
        .doc(bikename)
        .collection('MyList')
        .doc(todoid)
        .delete();
  }

  /**
   * This function is used to change the name of a bike.
   * 
   * @param bikeNameOld The old name of the bike.
   * @param bikeNameNew The new name of the bike.
   * @param biketype The type of the bike.
   */ ///
  Future setBikeName(
      String bikeNameOld, String bikeNameNew, BikeType biketype) async {
    await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(bikeNameOld)
        .get()
        .then((value) {
      if (value.exists) {
        userbikesetup
            .doc(userID)
            .collection('Bikes')
            .doc(bikeNameNew)
            .set(value.data()!);
      }
    });
    await userbikesetup
        .doc(userID)
        .collection('UserData')
        .doc('BikeList')
        .update({bikeNameOld: FieldValue.delete()});
    return await userbikesetup
        .doc(userID)
        .collection('UserData')
        .doc('BikeList')
        .set({bikeNameNew: biketype.biketype}, SetOptions(merge: true));
  }

  Future updateTodoList(
      String bikename, String todolistid, bool isdone) async {
    return await userbikesetup
        .doc(userID)
        .collection('ToDoList')
        .doc(bikename)
        .collection('MyList')
        .doc(todolistid)
        .update({'done': isdone});
  }

  //Delete functions
  Future deleteBike(String bikename) async {
    await userbikesetup.doc(userID).collection('Bikes').doc(bikename).delete();
    await userbikesetup
        .doc(userID)
        .collection('UserData')
        .doc('BikeList')
        .update({bikename: FieldValue.delete()});
  }

  Future deleteSetup(String bikename, String setup) async {
    var setups = await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(bikename)
        .collection(setup)
        .get();

    for (var doc in setups.docs) {
      await doc.reference.delete();
    }

    await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(bikename)
        .update({setup: FieldValue.delete()});
  }

  Future deleteSetting(
      String key, String bikename, String category, String setup) async {
    return await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(bikename)
        .collection(setup)
        .doc(category)
        .update({
      key: FieldValue.delete(),
    });
  }

  //Get functions (snapshots)
  Stream getSettings(String bikename, String category, String setup) {
    return userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(bikename)
        .collection(setup)
        .doc(category)
        .snapshots();
  }

  Stream getBikes() {
    return userbikesetup
        .doc(userID)
        .collection('UserData')
        .doc('BikeList')
        .snapshots();
  }

  Stream getSetups(String bikename) {
    return userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(bikename)
        .snapshots();
  }

  Stream getDocumentElement(String bikename, String category, String setup) {
    return userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(bikename)
        .collection(setup)
        .doc(category)
        .snapshots();
  }

  Stream getTodoList(String bikename) {
    return userbikesetup
        .doc(userID)
        .collection('ToDoList')
        .doc(bikename)
        .collection('MyList')
        .snapshots();
  }

  //get functions (single values)
  Future<String> getDefaultBike() async {
    try {
      DocumentSnapshot snapshot = await userbikesetup
          .doc(userID)
          .collection('UserData')
          .doc('DefaultBike')
          .get();
      if (snapshot.exists) {
        dynamic value = snapshot['default'];
        if (value != null) {
          return value.toString();
        } else {
          return "";
        }
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  Future<String> getFirstBike() async {
    final DocumentSnapshot documentSnapshot = await userbikesetup
        .doc(userID)
        .collection('UserData')
        .doc('BikeList')
        .get();

    final Map<String, dynamic>? data =
        documentSnapshot.data() as Map<String, dynamic>?;
    if (data == null) {
      return '';
    }
    final String firstField = data.entries.first.key.toString();
    return firstField;
  }

  Future<String> getBikeType(String bikename) async {
    try {
      DocumentSnapshot snapshot = await userbikesetup
          .doc(userID)
          .collection('UserData')
          .doc('BikeList')
          .get();

      if (snapshot.exists) {
        dynamic value = snapshot[bikename];
        if (value != null) {
          return value.toString();
        } else {
          return '""';
        }
      } else {
        return '""';
      }
    } catch (e) {
      return '""';
    }
  }

  Future getSetupInformation(String bikename, String setupname) async {
    try {
      DocumentSnapshot snapshot = await userbikesetup
          .doc(userID)
          .collection('Bikes')
          .doc(bikename)
          .get();

      if (snapshot.exists) {
        dynamic value = snapshot[setupname];
        if (value != null) {
          return value;
        }
        return '""';
      }
      return '""';
    } catch (e) {
      return '""';
    }
  }
}
