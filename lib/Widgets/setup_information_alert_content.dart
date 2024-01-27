import 'package:bikesetupapp/bike_enums/biketype.dart';
import 'package:bikesetupapp/database_service/database.dart';
import 'package:bikesetupapp/widgets/setup_information_list_element.dart';
import 'package:flutter/material.dart';

class SetupInformation extends StatelessWidget {
  final String userID;
  final String bikename;
  final String setupname;
  final BikeType biketype;
  const SetupInformation(
      {super.key,
      required this.userID,
      required this.bikename,
      required this.setupname,
      required this.biketype,});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            DatabaseService(userID).getSetupInformation(bikename, setupname),
        builder: ((context, snapshot) {
          if (ConnectionState.waiting == snapshot.connectionState) {
            return Center(
              child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor!)),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          } else if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else {
            Map<String, dynamic> setupinformation =
                snapshot.data as Map<String, dynamic>;
            return SizedBox(
                child: IntrinsicHeight(
                    child: Column(
              children: [
                SetupInformationListElement(name: 'Fork Type', value: setupinformation['fork'], visible: biketype.hasFork),
                SetupInformationListElement(name: 'Shock Type', value: setupinformation['shock'], visible: biketype.hasShock),
                SetupInformationListElement(name: 'Front Travel', value: '${setupinformation['fronttravel']} mm', visible: biketype.hasFork),
                SetupInformationListElement(name: 'Rear Travel', value: '${setupinformation['reartravel']} mm', visible: biketype.hasShock),
                SetupInformationListElement(name: 'Front Wheel Size', value: '${setupinformation['frontwheelsize']}"', visible: true),
                SetupInformationListElement(name: 'Rear Wheel Size', value: '${setupinformation['rearwheelsize']}"', visible: true),
              ],
            )));
          }
        }));
  }
}
