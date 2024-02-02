import 'package:bikesetupapp/bike_enums/biketype.dart';
import 'package:bikesetupapp/database_service/database.dart';
import 'package:bikesetupapp/widgets/setup_information_alert_content.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BikeAlerts {
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
                child: Text('Cancel',
                    style: Theme.of(context).textTheme.labelLarge)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
              ),
              child:
                  Text('Delete', style: Theme.of(context).textTheme.labelLarge),
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
                child: Text('Cancel',
                    style: Theme.of(context).textTheme.labelLarge)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
              ),
              child:
                  Text('Delete', style: Theme.of(context).textTheme.labelLarge),
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
                child:
                    Text('Ok', style: Theme.of(context).textTheme.labelLarge)),
          ],
        );
      },
    );
  }

  static Future<void> selectDefaultBike(
      BuildContext context, User user, Size size) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).cardTheme.color,
            title: Text(
              'Select Default Bike',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: StreamBuilder(
                stream: DatabaseService(user.uid).getBikes(),
                builder: (((context, AsyncSnapshot snapshot) {
                  if (ConnectionState.waiting == snapshot.connectionState) {
                    return const SizedBox(
                      height: 100,
                      width: 100,
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error'));
                  } else {
                    Map<String, dynamic>? bikes =
                        snapshot.data!.data() as Map<String, dynamic>?;
                    if (bikes == null) {
                      return const Center(
                        child: Text('No Bikes'),
                      );
                    } else {
                      return SizedBox(
                        height: size.height * 0.25,
                        width: size.width * 0.8,
                        child: ListView.builder(
                          itemCount: bikes.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: ListTile(
                              title: Text(bikes.keys.elementAt(index), style: Theme.of(context).textTheme.labelMedium,),
                              onTap: () {
                                DatabaseService(user.uid).setDefaultBike(
                                    bikes.keys.elementAt(index));
                                Navigator.of(context).pop();
                              },
                            ));
                          },
                        ),
                      );
                    }
                  }
                }))),
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
                  child: Text('Cancel',
                      style: Theme.of(context).textTheme.labelLarge)),
            ],
          );
        });
  }

  static Future<void> showSetupInformation(
      BuildContext context,
      Size size,
      String userID,
      String bikename,
      String setupname,
      BikeType biketype) async {
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
