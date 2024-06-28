import 'package:bikesetupapp/bike_enums/bike_type.dart';
import 'package:bikesetupapp/database_service/database.dart';
import 'package:bikesetupapp/widgets/setup_information_list_element.dart';
import 'package:flutter/material.dart';

class SetupInformation extends StatelessWidget {
  final String userID;
  final String uBikeID;
  final String uSetupID;
  final BikeType bikeType;
  const SetupInformation({
    super.key,
    required this.userID,
    required this.uBikeID,
    required this.uSetupID,
    required this.bikeType,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseService(userID).getSetupInformation(uBikeID, uSetupID),
        builder: ((context, snapshot) {
          if (ConnectionState.waiting == snapshot.connectionState) {
            return const SizedBox(
              height: 100.0,
              width: 100.0,
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          } else if (snapshot.data == null) {
            return const SizedBox(
              height: 100.0,
              width: 100.0,
              child: Text('Error'),
            );
          } else {
            var data = snapshot.data.data() as Map<String, dynamic>;
            return SizedBox(
                child: IntrinsicHeight(
                    child: Column(
              children: [
                SetupInformationListElement(
                    name: 'Fork Type',
                    value: data['fork'] ?? '',
                    visible: bikeType.hasFork),
                SetupInformationListElement(
                    name: 'Shock Type',
                    value: data['shock'] ?? '',
                    visible: bikeType.hasShock),
                SetupInformationListElement(
                    name: 'Front Travel',
                    value: '${data['front_travel']} mm',
                    visible: bikeType.hasFork),
                SetupInformationListElement(
                    name: 'Rear Travel',
                    value: '${data['rear_travel']} mm',
                    visible: bikeType.hasShock),
                SetupInformationListElement(
                    name: 'Front Wheel Size',
                    value: '${data['front_wheel_size']}"',
                    visible: true),
                SetupInformationListElement(
                    name: 'Rear Wheel Size',
                    value: '${data['rear_wheel_size']}"',
                    visible: true),
              ],
            )));
          }
        }));
  }
}
