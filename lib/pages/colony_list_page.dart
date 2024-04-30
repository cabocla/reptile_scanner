import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/colony.dart';
import 'package:reptile_scanner/pages/colony_detail_page.dart';
import 'package:reptile_scanner/pages/edit_colony_page.dart';
import 'package:reptile_scanner/services/database.dart';
import 'package:reptile_scanner/services/edit_colony_bloc.dart';

class ColonyListPage extends StatelessWidget {
  static const routeName = '/colony-list';
  const ColonyListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Provider(
                            create: (context) => EditColonyBloc(
                              database:
                                  Provider.of<Database>(context, listen: false),
                            ),
                            child: const EditColonyPage(),
                          )));
            },
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    Database database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Colony>>(
      stream: database.colonyStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No colony yet, add some'),
            );
          } else {
            List<Colony> colonyList = snapshot.data!;
            return ListView.builder(
                itemCount: colonyList.length,
                itemBuilder: (context, index) {
                  Colony colony = colonyList[index];
                  return ListTile(
                    title: Text(colony.colonyName),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ColonyDetailPage(colony: colony),
                          ));
                    },
                  );
                });
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        return const Center(
          child: Text('No colony yet, add some'),
        );
      },
    );
  }
}
