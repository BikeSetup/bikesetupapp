import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService(this.userID);
  String userID;

  final CollectionReference userbikesetup =
      FirebaseFirestore.instance.collection('UserBikeSetup');

  Future createBike(
      String bikename,
      Map<String, String> suspension,
      String forktravel,
      String shocktravel,
      String frontwheelsize,
      String rearwheelsize,
      bool isdefaultbike) async {
    await createFork(bikename, forktravel);
    await createShock(bikename, shocktravel);
    await createFrontTire(bikename, frontwheelsize);
    await createRearTire(bikename, rearwheelsize);
    await createGeneralSettings(bikename);
    if (isdefaultbike == true) {
      await setDefaultBike(bikename);
    }
    await createSetupList(bikename, suspension);
    return await userbikesetup
        .doc(userID)
        .collection('UserData')
        .doc('BikeList')
        .set({bikename: 'Fork:${suspension['fork']}|Shock:${suspension['shock']}'},
            SetOptions(merge: true));
  }

  Future createFork(String bikename, String forktravel) async {
    return await userbikesetup
        .doc(userID)
        .collection(bikename)
        .doc('ForkStandard')
        .set({
      'Pressure': '90',
      'Front Travel': forktravel,
    }, SetOptions(merge: true));
  }

  Future createShock(String bikename, String shocktravel) async {
    return await userbikesetup
        .doc(userID)
        .collection(bikename)
        .doc('ShockStandard')
        .set({'Pressure': '180', 'Shock Travel': shocktravel},
            SetOptions(merge: true));
  }

  Future createFrontTire(String bikename, String frontwheelsize) async {
    return await userbikesetup
        .doc(userID)
        .collection(bikename)
        .doc('FrontTireStandard')
        .set({'Pressure': '24', 'Wheel Size': frontwheelsize},
            SetOptions(merge: true));
  }

  Future createRearTire(String bikename, String rearwheelsize) async {
    return await userbikesetup
        .doc(userID)
        .collection(bikename)
        .doc('RearTireStandard')
        .set({'Pressure': '26', 'Wheel Size': rearwheelsize},
            SetOptions(merge: true));
  }

  Future createGeneralSettings(String bikename) async {
    return await userbikesetup
        .doc(userID)
        .collection(bikename)
        .doc('GeneralSettingsStandard')
        .set({'Distance': '90cm'}, SetOptions(merge: true));
  }

  Future setDefaultBike(String bikename) async {
    return await userbikesetup
        .doc(userID)
        .collection('UserData')
        .doc('DefaultBike')
        .set({'default': bikename}, SetOptions(merge: true));
  }

  Future createSetupList(
      String bikename, Map<String, dynamic> suspension) async {
    return await userbikesetup
        .doc(userID)
        .collection(bikename)
        .doc('SetupList')
        .set({'Standard': suspension}, SetOptions(merge: true));
  }

  Future deleteBike(String key, Map<String, String> setuplist) async {
    await userbikesetup
        .doc(userID)
        .collection(key)
        .doc('RearTireStandard')
        .delete();
    await userbikesetup
        .doc(userID)
        .collection(key)
        .doc('GeneralSettingsStandard')
        .delete();
    await userbikesetup
        .doc(userID)
        .collection(key)
        .doc('ShockStandard')
        .delete();
    await userbikesetup
        .doc(userID)
        .collection(key)
        .doc('ForkStandard')
        .delete();
    await userbikesetup
        .doc(userID)
        .collection(key)
        .doc('FrontTireStandard')
        .delete();
    await userbikesetup.doc(userID).collection(key).doc('SetupList').delete();
    await userbikesetup
        .doc(userID)
        .collection('UserData')
        .doc('BikeList')
        .update({
      key: FieldValue.delete(),
    });
  }

  Stream getSettings(String bikename, String category, String setup) {
    return userbikesetup
        .doc(userID)
        .collection(bikename)
        .doc('$category$setup')
        .snapshots();
  }

  Future getBikes() {
    return userbikesetup
        .doc(userID)
        .collection('UserData')
        .doc('BikeList')
        .get();
  }

  /*Future<String> getDocumentElement(
      String bikename, String category, String setup) async {
    final documentSnapshot = await userbikesetup
        .doc(userID)
        .collection(bikename)
        .doc('$category$setup')
        .get();

    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      if (data != null) {
        final element = data['Pressure'];
        if (element is String) {
          return element;
        }
      }
    }
    return '';
  }*/

  Stream getDocumentElement(
      String bikename, String category, String setup) {
    return userbikesetup
        .doc(userID)
        .collection(bikename)
        .doc('$category$setup')
        .snapshots();
  }

  Future<String> getSuspensionType(String bikename) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('UserBikeSetup').doc(userID).collection('UserData').doc('BikeList').get();

      if (snapshot.exists) {
        dynamic value = snapshot[bikename];
        if (value != null) {
          return value.toString();
        } else {
          return 'Value not found';
        }
      } else {
        return 'Document does not exist';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> getSetting(String bikename, String category, String setup, String key) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('UserBikeSetup').doc(userID).collection(bikename).doc('$category$setup').get();

      if (snapshot.exists) {
        dynamic value = snapshot[key];
        if (value != null) {
          return value.toString();
        } else {
          return 'Value not found';
        }
      } else {
        return 'Document does not exist';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Stream getDocumentElementSnap(String bikename, String category, String setup) {
    return userbikesetup
        .doc(userID)
        .collection(bikename)
        .doc('$category$setup')
        .snapshots();
  }
}


