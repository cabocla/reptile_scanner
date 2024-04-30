import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/user_data.dart';
import 'package:reptile_scanner/services/auth.dart';
import 'package:reptile_scanner/services/database.dart';

class SettingPage extends StatelessWidget {
  static const routeName = '/settings';
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    Database database = Provider.of<Database>(context, listen: false);
    return Consumer<UserData>(
      builder: (context, userData, _) {
        return ListView(
          children: [
            ListTile(
              title: const Text('Weight unit'),
              trailing: TextButton(
                child: Text(UserData.weightUnitString[userData.weightUnit]!),
                onPressed: () {},
              ),
            ),
            ListTile(
              title: const Text('Length unit'),
              trailing: TextButton(
                child: Text(UserData.lengthUnitString[userData.lengthUnit]!),
                onPressed: () {},
              ),
            ),
            ListTile(
              title: const Text('Currency'),
              trailing: Text(userData.currency),
              onTap: () async {
                showCurrencyPicker(
                    context: context,
                    onSelect: (currency) {
                      UserData newUserData =
                          userData.updateCurency(currency.code);
                      database.updateUserData(newUserData);
                      Navigator.pop(context);
                    });
              },
            ),
            ListTile(
              title: TextButton(
                child: const Text('Log out'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Log out?'),
                            content:
                                const Text('Are you sure you want to log out?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: const Text('Yes'),
                                onPressed: () {
                                  Provider.of<Auth>(context, listen: false)
                                      .signOut();
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                },
                              ),
                            ],
                          ));
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
