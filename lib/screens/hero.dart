import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/services.dart';


class HeroScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;

  return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Hero'),
      ),
      body: HeroWidget(loggedIn: loggedIn, db: db, user: user)
  );
  }
}

class HeroWidget extends StatelessWidget {
  const HeroWidget({
    Key key,
    @required this.loggedIn,
    @required this.db,
    @required this.user,
  }) : super(key: key);

  final bool loggedIn;
  final DatabaseService db;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (loggedIn) ...[
              SizedBox(
                child: Image.asset('assets/dog.png'),
                width: 150,
              ),

              StreamProvider<List<Weapon>>.value(
                stream: db.streamWeapons(user),
                child: WeaponsList(),
              ),

              StreamBuilder<SuperHero>(
                stream: db.streamHero(user.uid),
                builder: (context, snapshot) {
                  var hero = snapshot.data;

                  if (hero != null) {
                    return Column(
                      children: <Widget>[
                        Text('Equip ${hero.name}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              child: Text('Add Knife'),
                              onPressed: () => db.addWeapon(user,
                                  {'name': 'knife', 'hitpoints': 20, 'img': '🗡️'}),
                            ),
                            RaisedButton(
                              child: Text('Add Gun'),
                              onPressed: () => db.addWeapon(user,
                                  {'name': 'gun', 'hitpoints': 75, 'img': '🔫'}),
                            ),
                            RaisedButton(
                              child: Text('Add Veggie'),
                              onPressed: () => db.addWeapon(user, {
                                    'name': 'cucumber',
                                    'hitpoints': 5,
                                    'img': '🥒'
                                  }),
                            )
                          ],
                        ),
                      ],
                    );
                  } else {
                    return RaisedButton(
                        child: Text('Create'),
                        onPressed: () => db.createHero(user));
                  }
                },
              ),

              // RaisedButton(child: Text('Sign out'), onPressed: auth.signOut),
            ],
            if (!loggedIn) ...[
              RaisedButton(
                child: Text('Login'),
                onPressed: FirebaseAuth.instance.signInAnonymously,
              )
            ]
          ],
        ),
      );
  }
}

class WeaponsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var weapons = Provider.of<List<Weapon>>(context);
    var user = Provider.of<FirebaseUser>(context);

    return Container(
      height: 300,
      child: ListView(
        children: weapons.map((weapon) {
          return Card(
            child: ListTile(
              leading: Text(weapon.img, style: TextStyle(fontSize: 50)),
              title: Text(weapon.name),
              subtitle: Text('Deals ${weapon.hitpoints} hitpoints of damage'),
              onTap: () => DatabaseService().removeWeapon(user, weapon.id),
            ),
          );
        }).toList(),
      ),
    );
  }
}
