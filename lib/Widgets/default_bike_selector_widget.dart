import 'package:bikesetupapp/alert_dialogs/bike_alert_dialogs.dart';
import 'package:bikesetupapp/database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DefaultBikeSelector extends StatelessWidget {
  final User user;
  final Size size;
  const DefaultBikeSelector(
      {super.key, required this.user, required this.size});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
                width: size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                      itemCount: bikes.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Card(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: ListTile(
                                title: Text(
                                  bikes.keys.elementAt(index),
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                onTap: () {
                                  DatabaseService(user.uid).setDefaultBike(
                                      bikes.keys.elementAt(index));
                                  Navigator.of(context).pop();
                                },
                                trailing: IconButton(
                                  onPressed: () {
                                    BikeAlerts.renameBike(context, bikes.keys.elementAt(index), bikes.values.elementAt(index));
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .color),
                                )));
                      },
                    )
                  ],
                ),
              );
            }
          }
        })));
  }
}
