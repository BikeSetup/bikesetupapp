import 'package:bikesetupapp/app_pages/bike_selector_page.dart';
import 'package:bikesetupapp/app_pages/settings_page.dart';
import 'package:bikesetupapp/widgets/drawer_bike_list.dart';
import 'package:bikesetupapp/bike_enums/bike_type.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavDrawer extends StatefulWidget {
  final String bikeName;
  final BikeType bikeType;
  final String chosenSetup;
  final User? user;
  const NavDrawer(
      {super.key,
      required this.bikeName,
      required this.bikeType,
      required this.chosenSetup,
      required this.user});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
        width: size.width,
        child: Drawer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              SizedBox(
                  width: size.width,
                  height: size.height * 0.20,
                  child: DrawerHeader(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      child: Center(
                        child: ListTile(
                            leading: widget.user != null &&
                                    widget.user!.photoURL != null
                                ? Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          '${widget.user?.photoURL}'),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      backgroundImage: const AssetImage(
                                          'assets/incognito.png'),
                                    ),
                                  ),
                            title: Text('Bike Setup',
                                style: Theme.of(context).textTheme.titleLarge),
                            subtitle: widget.user != null &&
                                    widget.user!.email != null
                                ? Text(
                                    '${widget.user?.email}',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  )
                                : null),
                      ))),
              Expanded(
                child: SizedBox(
                    height: size.height * 0.73,
                    child: BikeList(
                      user: widget.user,
                      bikeName: widget.bikeName,
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => SettingsPage(
                                  bikeName: widget.bikeName,
                                  bikeType: widget.bikeType,
                                  chosenSetup: widget.chosenSetup,
                                )));
                      },
                      style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .floatingActionButtonTheme
                              .backgroundColor),
                      child: Text(
                        'Settings',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.user != null) {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  BikeTypeSelector(
                                    user: widget.user!,
                                  )));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('No User logged in'),
                          ));
                        }
                      },
                      style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .floatingActionButtonTheme
                              .backgroundColor),
                      child: Text(
                        'New Bike',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
