import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/feeder.dart';
import 'package:reptile_scanner/models/feeder_library.dart';
import 'package:reptile_scanner/pages/edit_feeder_page.dart';
import 'package:reptile_scanner/services/database.dart';
import 'package:reptile_scanner/services/edit_feeder_bloc.dart';

class FeederListPage extends StatelessWidget {
  static const routeName = '/feeder-list';
  const FeederListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Database database = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: const Text(
              '+ New Feeder',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Provider(
                    create: (context) => EditFeederBloc(
                      database: database,
                    ),
                    child: const EditFeederPage(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    Database database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Feed>>(
        stream: database.feederStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Feed> feederList = snapshot.data!;
            feederList.addAll(feederLibrary);
            return ListView.builder(
              itemCount: feederList.length,
              itemBuilder: (context, index) {
                Feed feed = feederList[index];
                return ListTile(
                  title: Text(feed.feedName),
                  subtitle: Text(feed.size),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Provider(
                            create: (context) => EditFeederBloc(
                              oldFeed: feed,
                              database: database,
                            ),
                            child: const EditFeederPage(),
                          ),
                        ));
                  },
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: Text('No feeder yet, add some'),
            );
          }
        });
  }
}
