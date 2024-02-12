import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bikesetupapp/bike_enums/category.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  DatabaseService(this.userID);
  String userID;

  /// Collection reference for the 'UserBikeSetup' collection in the Firestore database.
  final CollectionReference userbikesetup =
      FirebaseFirestore.instance.collection('UserBikeSetup');

  /// Creates a new bike in the database.
  ///
  /// The [bikename] parameter specifies the name of the bike.
  /// The [setupinformation] parameter is a map that contains the setup information for the bike.
  /// The [biketype] parameter specifies the type of the bike.
  ///
  /// Returns the unique identifier of the created bike.
  Future<String> createBike(String bikename,
      Map<String, String> setupinformation, String biketype) async {
    final String ubid = const Uuid().v4();
    final String usid = const Uuid().v4();

    await createSetup(ubid, usid, 'Default', setupinformation);

    if (await getDefaultBike() == "") {
      await setDefaultBike(ubid);
    }

    await setDefaultSetup(ubid, usid);

    await setTodo(ubid, 'MyFirstTask', 'This is my first task', 'Breaks');

    await userbikesetup.doc(userID).collection('Bikes').doc(ubid).set({
      'bikename': bikename,
      'biketype': biketype,
    }, SetOptions(merge: true));

    return ubid;
  }

  /// Creates a new setup in the database.
  ///
  /// The [ubid] parameter represents the user ID.
  /// The [usid] parameter represents the setup ID.
  /// The [setupname] parameter represents the name of the setup.
  /// The [setupinformation] parameter is a map containing additional setup information.
  ///
  /// This method creates a fork, shock, front tire, rear tire, general settings,
  /// and adds the setup to the setup list in the database.
  Future createSetup(
    String ubid,
    String usid,
    String setupname,
    Map<String, String> setupinformation,
  ) async {
    await createFork(ubid, usid);
    await createShock(ubid, usid);
    await createFrontTire(ubid, usid);
    await createRearTire(ubid, usid);
    await createGeneralSettings(ubid, usid);
    await createSetupList(ubid, usid, setupname, setupinformation);
  }

  /// Creates fork category with default values for the specified [ubid] and [usid] in the database.
  ///
  /// The [ubid] parameter represents the user's unique identifier.
  /// The [usid] parameter represents the user's session identifier.
  Future createFork(String ubid, String usid) async {
    await setSetting('Pressure', '90', ubid, Category.fork.category, usid);
  }

  /// Creates shock category with default values for the specified [ubid] and [usid] in the database.
  ///
  /// The [ubid] parameter represents the user's unique identifier.
  /// The [usid] parameter represents the user's session identifier.
  Future createShock(String ubid, String usid) async {
    await setSetting('Pressure', '180', ubid, Category.shock.category, usid);
  }

  /// Creates front tire category with default values for the specified [ubid] and [usid] in the database.
  ///
  /// The [ubid] parameter represents the user's unique identifier.
  /// The [usid] parameter represents the user's session identifier.
  Future createFrontTire(String ubid, String usid) async {
    await setSetting('Pressure', '26', ubid, Category.fronttire.category, usid);
  }

  /// Creates rear tire category with default values for the specified [ubid] and [usid] in the database.
  ///
  /// The [ubid] parameter represents the user's unique identifier.
  /// The [usid] parameter represents the user's session identifier.
  Future createRearTire(String ubid, String usid) async {
    await setSetting('Pressure', '26', ubid, Category.reartire.category, usid);
  }

  /// Creates general settings category with default values for the specified [ubid] and [usid] in the database.
  ///
  /// The [ubid] parameter represents the user's unique identifier.
  /// The [usid] parameter represents the user's session identifier.
  Future createGeneralSettings(String ubid, String usid) async {
    await setSetting(
        'Reach', '450mm', ubid, Category.generalsettings.category, usid);
    await setSetting(
        'Stackhight', '20mm', ubid, Category.generalsettings.category, usid);
    await setSetting(
        'Seathight', '35mm', ubid, Category.generalsettings.category, usid);
  }

  /// Creates a setup list in the database.
  ///
  /// Parameters:
  /// - [ubid]: The unique identifier of the user's bike.
  /// - [usid]: The unique identifier of the setup list.
  /// - [setupname]: The name of the setup list.
  /// - [setupinformation]: A map containing the setup information.
  ///
  /// Returns:
  /// - A [Future] that completes when the setup list is created in the database.
  Future createSetupList(String ubid, String usid, String setupname,
      Map<String, dynamic> setupinformation) {
    final Map<String, dynamic> setuplistdocument = <String, dynamic>{};
    setuplistdocument.addAll(setupinformation);
    setuplistdocument['setupname'] = setupname;

    return userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(ubid)
        .collection('SetupList')
        .doc(usid)
        .set(setuplistdocument, SetOptions(merge: true));
  }

  /// Sets the default bike for the user.
  ///
  /// The [ubid] parameter is the ID of the bike to set as the default.
  ///
  /// Returns a [Future] that completes when the operation is done.
  ///
  /// Throws:
  /// - [FirebaseException]: If an error occurs while accessing the database.
  Future setDefaultBike(String ubid) {
    return userbikesetup
        .doc(userID)
        .set({'defaultbike': ubid}, SetOptions(merge: true));
  }

  /// Sets the default setup for a bike in the database.
  ///
  /// Parameters:
  /// - [ubid]: The unique identifier of the bike.
  /// - [usid]: The unique identifier of the setup.
  ///
  /// Throws:
  /// - [FirebaseException]: If an error occurs while accessing the database.
  ///
  /// Returns a [Future] that completes when the default setup is successfully set in the database.
  Future setDefaultSetup(String ubid, String usid) {
    return userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(ubid)
        .set({'defaultSetup': usid}, SetOptions(merge: true));
  }

  /// Sets a setting in the database for specific bike and setup.
  ///
  /// The [key] parameter specifies the key of the setting.
  /// The [value] parameter specifies the value of the setting.
  /// The [ubid] parameter specifies the unique bike ID.
  /// The [category] parameter specifies the category of the setting.
  /// The [usid] parameter specifies the unique user ID.
  ///
  /// Throws:
  /// - [FirebaseException]: If an error occurs while accessing the database.
  ///
  /// Returns a [Future] that completes when the setting is successfully set in the database.
  Future setSetting(
      String key, String value, String ubid, String category, String usid) {
    return userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(ubid)
        .collection(usid)
        .doc(category)
        .set({key: value}, SetOptions(merge: true));
  }

  /// Edits a setting in the database for a specific bike and setup.
  /// Parameters:
  /// [key] - The key of the setting to be edited.
  /// [value] - The new value for the setting.
  /// [ubid] - The unique identifier of the bike.
  /// [category] - The category of the setting.
  /// [usid] - The unique identifier of the user.
  ///
  /// Returns a [Future] that completes when the setting is successfully edited.
  Future editSetting(
      String key, String value, String ubid, String category, String usid) {
    return userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(ubid)
        .collection(usid)
        .doc(category)
        .update({key: value});
  }

  /// Sets a new todo item in the database.
  ///
  /// Parameters:
  /// - The [ubid] parameter specifies the unique identifier for the todo item.
  /// - The [taskname] parameter specifies the name of the task.
  /// - The [taskdescription] parameter specifies the description of the task.
  /// - The [part] parameter specifies the part associated with the task.
  ///
  /// Returns a [Future] that completes when the todo item is successfully set in the database.
  Future setTodo(
      String ubid, String taskname, String taskdescription, String part) {
    return userbikesetup
        .doc(userID)
        .collection('ToDoList')
        .doc(ubid)
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

  /// Renames a bike in the database.
  ///
  /// Parameters:
  /// - The [ubid] parameter is the unique identifier of the bike.
  /// - The [bikename] parameter is the new name for the bike.
  ///
  /// Throws:
  /// - [FirebaseException]: If there is an error accessing the database.
  ///
  /// Returns a [Future] that completes when the bike is successfully renamed.
  Future renameBike(String ubid, String bikename) {
    return userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(ubid)
        .update({'bikename': bikename});
  }

  /// Edits a todo item in the database.
  ///
  /// Parameters:
  /// - [ubid]: The unique identifier of the user bike setup.
  /// - [docID]: The unique identifier of the todo item.
  /// - [taskname]: The name of the task.
  /// - [taskdescription]: The description of the task.
  /// - [part]: The part associated with the task.
  /// - [isdone]: Indicates whether the task is done or not.
  ///
  /// Throws:
  /// - [FirebaseException]: If there is an error accessing the database.
  ///
  /// Returns A [Future] that completes when the todo item is successfully edited.
  Future editTodo(String ubid, String docID, String taskname,
      String taskdescription, String part, bool isdone) {
    return userbikesetup
        .doc(userID)
        .collection('ToDoList')
        .doc(ubid)
        .collection('MyList')
        .doc(docID)
        .set({
      'taskname': taskname,
      'taskdescription': taskdescription,
      'Part': part,
      'done': isdone,
    }, SetOptions(merge: true));
  }

  /// Deletes a todo item for a bike from the database.
  ///
  /// Parameters:
  /// - [ubid]: The unique identifier of the user bike setup.
  /// - [todoid]: The unique identifier of the todo item.
  ///
  /// Throws:
  ///   [FirebaseException]: If there is an error accessing the database.
  ///
  /// Returns: A [Future] that completes when the todo item is successfully deleted.
  Future deleteTodo(String ubid, String todoid) async {
    await userbikesetup
        .doc(userID)
        .collection('ToDoList')
        .doc(ubid)
        .collection('MyList')
        .doc(todoid)
        .delete();
  }

  /// Updates the status of a todo item in the database.
  ///
  /// Parameters:
  /// - The [ubid] parameter is the unique identifier of the user bike setup.
  /// - The [todolistid] parameter is the unique of the todo list.
  /// - The [isdone] parameter indicates whether the todo item is done or not.
  ///
  /// Throws:
  /// - [FirebaseException]: If there is an error accessing the database.
  ///
  /// Returns a [Future] that completes when the update is successful.
  Future updateTodoList(String ubid, String todolistid, bool isdone) async {
    await userbikesetup
        .doc(userID)
        .collection('ToDoList')
        .doc(ubid)
        .collection('MyList')
        .doc(todolistid)
        .update({'done': isdone});
  }

  //Delete functions

  /// Deletes a bike from the database.
  ///
  /// Parameters:
  /// - [ubid]: The unique identifier of the bike to be deleted.
  ///
  /// Throws:
  /// - [FirebaseException]: If there is an error accessing the database.
  ///
  /// Returns: A [Future] that completes when the bike is successfully deleted.
  Future deleteBike(String ubid) async {
    var setups = await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(ubid)
        .collection('SetupList')
        .get();
    for (var doc in setups.docs) {
      await deleteSetup(ubid, doc.id);
    }

    await userbikesetup.doc(userID).collection('Bikes').doc(ubid).delete();
  }

  /// Deletes a bike setup from the database.
  ///
  /// Parameters:
  /// - [ubid]: The ID of the user's bike.
  /// - [usid]: The ID of the setup to be deleted.
  ///
  /// Throws:
  /// - [FirebaseException]: If there is an error accessing the database.
  ///
  /// Returns: A [Future] that completes when the setup is successfully deleted.
  Future deleteSetup(String ubid, String usid) async {
    var setups = await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(ubid)
        .collection(usid)
        .get();

    for (var doc in setups.docs) {
      await doc.reference.delete();
    }

    await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(ubid)
        .collection('SetupList')
        .doc(usid)
        .delete();
  }

  /// Deletes a setting from the database for a specific bike and setup.
  ///
  /// Parameters:
  /// - The [key] parameter specifies the key of the setting to be deleted.
  /// - The [ubid] parameter specifies the unique identifier of the bike.
  /// - The [category] parameter specifies the category of the setting.
  /// - The [usid] parameter specifies the unique identifier of the user.
  ///
  /// Throws:
  /// - [FirebaseException]: If there is an error accessing the database.
  ///
  /// Returns: A [Future] that completes when the setting is successfully deleted.
  Future deleteSetting(
      String key, String ubid, String category, String usid) async {
    await userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(ubid)
        .collection(usid)
        .doc(category)
        .update({
      key: FieldValue.delete(),
    });
  }

  //Get functions (snapshots)

  /// Retrieves the settings for a specific bike, category, and setup ID.
  ///
  /// The [ubid] parameter represents the unique ID of the bike.
  /// The [category] parameter represents the category of the settings.
  /// The [usid] parameter represents the unique ID of the setup.
  ///
  /// Returns a [Stream] that emits snapshots of the settings document.
  Stream getSettings(String ubid, String category, String usid) {
    return userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(ubid)
        .collection(usid)
        .doc(category)
        .snapshots();
  }

  /// Returns a [stream] of bikes from the database.
  Stream getBikes() {
    return userbikesetup.doc(userID).collection('Bikes').snapshots();
  }

  /// Retrieves a stream of setups for a given user bike ID.
  ///
  /// The [ubid] parameter specifies the user bike ID for which the setups are retrieved.
  /// Returns a [Stream] that emits snapshots of the setup list collection.
  Stream getSetups(String ubid) {
    return userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(ubid)
        .collection('SetupList')
        .snapshots();
  }

  /// Retrieves a stream of a specific document element from the database.
  ///
  /// The [ubid] parameter represents the unique identifier of the user's bike setup.
  /// The [category] parameter represents the category of the document.
  /// The [usid] parameter represents the unique identifier of the user.
  ///
  /// Returns a [Stream] that emits snapshots of the specified document element.
  Stream getDocumentElement(String ubid, String category, String usid) {
    return userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(ubid)
        .collection(usid)
        .doc(category)
        .snapshots();
  }

  /// Retrieves a stream of todo list items for a specific user bike setup.
  ///
  /// The [ubid] parameter is the unique identifier of the user bike setup.
  /// Returns a [Stream] that emits snapshots of the todo list items.
  Stream getTodoList(String ubid) {
    return userbikesetup
        .doc(userID)
        .collection('ToDoList')
        .doc(ubid)
        .collection('MyList')
        .snapshots();
  }

  //get functions (single values)

  /// Retrieves the default bike from the database for the current user.
  ///
  /// Returns the default bike as a [string], or an empty string if it doesn't exist.
  Future<String> getDefaultBike() async {
    DocumentSnapshot snapshot;
    dynamic value;
    try {
      snapshot = await userbikesetup.doc(userID).get();
      if (!snapshot.exists) {
        return "";
      }
      value = snapshot['defaultbike'];
    } catch (e) {
      return "";
    }
    if (value == null) {
      return "";
    }
    return value.toString();
  }

  /// Retrieves the default setup for a given user bike ID.
  ///
  /// The [ubid] parameter is the user bike ID.
  ///
  /// Returns a [Future] that completes with a [String] representing the default setup.
  /// If the user bike ID does not exist or if the default setup is not available, an empty string is returned.
  Future<String> getDefaultSetup(String ubid) async {
    DocumentSnapshot snapshot;
    dynamic value;
    try {
      snapshot =
          await userbikesetup.doc(userID).collection('Bikes').doc(ubid).get();
      if (!snapshot.exists) {
        return "";
      }
      value = snapshot['defaultSetup'];
    } catch (e) {
      return "";
    }
    return value.toString();
  }

  /// Retrieves the name of a bike from its unique ID.
  ///
  /// Parameters:
  /// - [ubid]: The unique ID of the bike.
  ///
  /// Returns the name of the bike as a [String]. If the bike does not exist or if an error occurs,
  /// an empty string is returned.
  Future<String> getBikeNameFromID(String ubid) async {
    DocumentSnapshot snapshot;
    dynamic value;
    try {
      snapshot =
          await userbikesetup.doc(userID).collection('Bikes').doc(ubid).get();
      if (!snapshot.exists) {
        return "";
      }
      value = snapshot['bikename'];
    } catch (e) {
      return "";
    }

    if (value == null) {
      return "";
    }
    return value.toString();
  }

  /// Retrieves the Setup name for a given bike ID and setup ID.
  ///
  /// Parameters:
  /// - The [ubid] Parameter specifies the unique bike identifier.
  /// - The [usid] Parameter specifies the unique setup identifier.
  ///
  /// Returns a [Future] that completes with a [String] representing the setup name.
  /// If the user bike ID or setup ID is not found or an error occurs, an empty string is returned.
  Future<String> getSetupNameFromID(String ubid, String usid) async {
    DocumentSnapshot snapshot;
    dynamic value;
    try {
      snapshot = await userbikesetup
          .doc(userID)
          .collection('Bikes')
          .doc(ubid)
          .collection('SetupList')
          .doc(usid)
          .get();
      if (!snapshot.exists) {
        return "";
      }
      value = snapshot['setupname'];
    } catch (e) {
      return "";
    }
    if (value == null) {
      return "";
    }
    return value.toString();
  }

  /// Retrieves the bike type for a given user bike ID.
  ///
  /// Parameters:
  /// - The [ubid] Parameter specifies the ub unique bike identifier.
  ///
  /// Returns a [Future] that completes with a [String] representing the bike type.
  /// If the user bike ID is not found or an error occurs, an empty string is returned.
  Future<String> getBikeType(String ubid) async {
    DocumentSnapshot snapshot;
    dynamic value;
    try {
      snapshot =
          await userbikesetup.doc(userID).collection('Bikes').doc(ubid).get();
      if (!snapshot.exists) {
        return "";
      }
      value = snapshot['biketype'];
    } catch (e) {
      return "";
    }
    if (value == null) {
      return "";
    }
    return value.toString();
  }

  /// Retrieves the setup information for a specific bike setup.
  ///
  /// The [ubid] parameter represents the unique identifier of the bike.
  /// The [usid] parameter represents the unique identifier of the setup.
  ///
  /// Returns a [Future] that resolves to the setup information.
  Future getSetupInformation(String ubid, String usid) {
    return userbikesetup
        .doc(userID)
        .collection('Bikes')
        .doc(ubid)
        .collection('SetupList')
        .doc(usid)
        .get();
  }

  /// Retrieves the setup information as a map for a given user bike ID (ubid) and user setup ID (usid).
  ///
  /// Parameters:
  /// - The [ubid] specifies the unique bike identifier
  /// - The [usid] specifies the unique setup identifier
  ///
  /// Returns a [Future] that resolves to a Map<String, dynamic> containing the setup information.
  /// If the setup information does not exist, an empty map is returned.
  Future<Map<String, dynamic>> getSetupInformationAsMap(
      String ubid, String usid) async {
    DocumentSnapshot snapshot = await getSetupInformation(ubid, usid);

    if (!snapshot.exists) {
      return {};
    }
    return snapshot.data() as Map<String, dynamic>;
  }
}
