import 'package:bikesetupapp/bike_enums/biketype.dart';
import 'package:bikesetupapp/database_service/database.dart';
import 'package:bikesetupapp/widgets/setup_information_alert_content.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlertDialogs {
  static Future<void> newKey(BuildContext context, User user, String bikename,
      String category, String setup) async {
    String key = "";
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardTheme.color,
          title: Text('New Category',
              style: Theme.of(context).textTheme.labelLarge),
          content: TextFormField(
            cursorColor: Theme.of(context).textTheme.labelMedium!.color,
            autofocus: true,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).textTheme.labelMedium!.color!),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).textTheme.labelMedium!.color!),
                borderRadius: BorderRadius.circular(10),
              ),
              hintStyle: Theme.of(context).textTheme.labelSmall,
              hintText: 'Category Name',
            ),
            onChanged: (value) {
              key = value;
            },
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.labelMedium,
                )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
              ),
              child: Text(
                'Enter',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              onPressed: () {
                if (key == "") {
                  return;
                } else {
                  Navigator.of(context).pop();
                  newValue(context, key, user, bikename, category, setup);
                }
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> newValue(BuildContext context, String key, User user,
      String bikename, String category, String setup) async {
    String value = "";
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardTheme.color,
          title: Text(key, style: Theme.of(context).textTheme.labelLarge),
          content: TextFormField(
            cursorColor: Theme.of(context).textTheme.labelMedium!.color,
            autofocus: true,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).textTheme.labelMedium!.color!),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).textTheme.labelMedium!.color!),
                borderRadius: BorderRadius.circular(10),
              ),
              hintStyle: Theme.of(context).textTheme.labelSmall,
              hintText: 'Value',
            ),
            onChanged: (val) {
              value = val;
            },
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel',
                    style: Theme.of(context).textTheme.labelLarge)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
              ),
              child:
                  Text('Enter', style: Theme.of(context).textTheme.labelLarge),
              onPressed: () {
                Navigator.of(context).pop();
                DatabaseService(user.uid)
                    .setSetting(key, value, bikename, category, setup);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> editValue(BuildContext context, User user, String key,
      String value, String bikename, String category, String setup) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardTheme.color,
          title: Text(
            key,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: TextFormField(
            cursorColor: Theme.of(context).textTheme.labelMedium!.color,
            autofocus: true,
            style: Theme.of(context).textTheme.titleMedium,
            initialValue: value,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).textTheme.labelMedium!.color!),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).textTheme.labelMedium!.color!),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (val) {
              value = val;
            },
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.labelLarge,
                )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
              ),
              child: Text(
                'Enter',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () {
                if (key == "Pressure" &&
                    value.trim().replaceAll(',', '').length > 3) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pressure must be 3 digits or less'),
                    ),
                  );
                  return;
                } else {
                  Navigator.of(context).pop();
                  DatabaseService(user.uid).editSetting(
                      key.trim(), value.trim(), bikename, category, setup);
                }
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> deleteCategory(BuildContext context, User user,
      String key, String bikename, String category, String setup) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardTheme.color,
          title: Text(
            'Delete Category',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          content: Text(
            'Are you sure you want to delete this category?',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel',
                    style: Theme.of(context).textTheme.labelMedium)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
              ),
              child: Text(
                'Delete',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                DatabaseService(user.uid)
                    .deleteSetting(key, bikename, category, setup);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> deleteBike(
      BuildContext context, User user, String bikename) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardTheme.color,
          title: Text(
            'Deleting Bike',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete this Bike?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel', style: Theme.of(context).textTheme.labelLarge)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .floatingActionButtonTheme
                        .backgroundColor,
                  ),
              child: Text('Delete', style: Theme.of(context).textTheme.labelLarge),
              onPressed: () {
                Navigator.of(context).pop();
                DatabaseService(user.uid).deleteBike(bikename);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> deleteSetup(BuildContext context, User user,
      String bikename, String setupname) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardTheme.color,
          title: Text(
            'Deleting Setup',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete this Setup?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel', style: Theme.of(context).textTheme.labelLarge)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .floatingActionButtonTheme
                        .backgroundColor,
                  ),
              child: Text('Delete', style: Theme.of(context).textTheme.labelLarge),
              onPressed: () {
                Navigator.of(context).pop();
                DatabaseService(user.uid).deleteSetup(bikename, setupname);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> deleteBikeError(BuildContext context, String type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardTheme.color,
          title: Text('Deleting $type',
              style: Theme.of(context).textTheme.titleLarge),
          content: Text(
            'You must have at least one $type',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok', style: Theme.of(context).textTheme.labelLarge)),
          ],
        );
      },
    );
  }

  static Future<void> showSetupInformation(BuildContext context, Size size,
      String userID, String bikename, String setupname, BikeType biketype) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).cardTheme.color,
            title: Text(
              setupname,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: SetupInformation(
              userID: userID,
              bikename: bikename,
              setupname: setupname,
              biketype: biketype,
              size: size,
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .floatingActionButtonTheme
                        .backgroundColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Ok',
                    style: Theme.of(context).textTheme.titleMedium,
                  ))
            ],
          );
        });
  }
}
