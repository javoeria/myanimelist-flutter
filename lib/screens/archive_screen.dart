import 'package:flutter/material.dart';

class ArchiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> items = ['Spring 2020', 'Winter 2020'];
    for (int i = 2019; i >= 1917; i--) {
      items.add('Fall $i');
      items.add('Summer $i');
      items.add('Spring $i');
      items.add('Winter $i');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Archive'),
      ),
      body: Scrollbar(
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(height: 0.0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items.elementAt(index)),
              onTap: () {
                Navigator.pop(context, items.elementAt(index));
              },
            );
          },
        ),
      ),
    );
  }
}
