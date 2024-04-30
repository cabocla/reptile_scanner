import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/colony.dart';
import 'package:reptile_scanner/pages/edit_colony_page.dart';
import 'package:reptile_scanner/services/database.dart';
import 'package:reptile_scanner/services/edit_colony_bloc.dart';

class ColonyDetailPage extends StatelessWidget {
  final Colony colony;
  const ColonyDetailPage({
    Key? key,
    required this.colony,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Database database = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Provider<EditColonyBloc>(
                          create: (context) => EditColonyBloc(
                              database: database, oldColony: colony),
                          child: const EditColonyPage()),
                    ));
              } else if (value == 'delete') {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Are you sure?'),
                          content: const Text('Pet will be deleted'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  database.deleteColony(colony);
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                },
                                child: const Text('Yes')),
                          ],
                        ));
              }
            },
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container();
  }
}
