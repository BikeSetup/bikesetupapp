import 'package:bikesetupapp/Pages/newbike.dart';
import 'package:bikesetupapp/Pages/settings.dart';
import 'package:bikesetupapp/Widgets/navdrawerbikelist.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavDrawer extends StatefulWidget {
  final String bikename;
  final User? user;
  const NavDrawer({Key? key, required this.user, required this.bikename}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    /*void removebike(index, bikes) async {
      final CollectionReference userbikeslist =
          FirebaseFirestore.instance.collection('UserBikeSetup');
      await userbikeslist
          .doc(user?.uid)
          .collection('UserData')
          .doc('DefaultBike')
          .get()
          .then((value) {
        defaultbikemap = value.data();
      });
      if (bikes.keys.elementAt(index) != defaultbikemap!['default']) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Delete Bike'),
                content: const Text(
                  'Do you really want to delete this bike?',
                  style: TextStyle(color: Colors.black),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No')),
                  TextButton(
                      onPressed: () {
                        DatabaseService(user!.uid).deleteBike(
                            bikes.keys.elementAt(index), {'Standard': 'test'});
                        Navigator.of(context).pop();
                      },
                      child: const Text('Yes'))
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                content: Text(
                  "Can't delete default Bike",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              );
            });
      }
    }*/

    return SizedBox(
        width: size.width / 1.33,
        child: Drawer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            //padding: EdgeInsets.zero,
            children: [
              SizedBox(
                  width: size.width * 0.75,
                  height: size.height * 0.20,
                  child: DrawerHeader(
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                    child: Center(child: ListTile(
                      
                      leading: widget.user != null
                  ? Padding(
                      padding: const EdgeInsets.all(5),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage('${widget.user?.photoURL}'),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(5),
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        backgroundImage:
                            const AssetImage('assets/incognito.png'),
                      ),
                    ),
                      title: Text('Bike Setup',
                            style: Theme.of(context).textTheme.titleLarge),
                      subtitle: widget.user != null ? Text('${widget.user?.email}', style: Theme.of(context).textTheme.labelMedium,) : Text('No User logged in', style: Theme.of(context).textTheme.labelMedium,),
                    ),)
                  )),
              SizedBox(
                  height: size.height * 0.65,
                  child: BikeList(user: widget.user)),
              SizedBox(
                  height: size.height * 0.1,
                  width: size.width * 0.75,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: size.width * 0.75 / 2,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (widget.user != null) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                NewBike(
                                                    user: widget.user!,
                                                  isnewbike: true,
                                                  isdefaultbike: false,
                                                  bike: '',
                                                )));
                                    } else {
                                      // TODO: add alert dialog
                                    }

                                    
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor),
                                  child: Text('New Bike', style: Theme.of(context).textTheme.labelLarge,)),
                            )),
                        SizedBox(
                          width: size.width * 0.75 / 2,
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SettingsPage(bikename: widget.bikename,)));
                              },
                              icon: const Icon(Icons.settings)),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}
