import 'package:flutter/material.dart';

class ArchiveScreen extends StatelessWidget {
  List<String> lastSeasons() {
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    List<String> common = ['Spring $year', 'Winter $year'];
    if (month == 1) {
      return common;
    } else if (month >= 2 && month < 5) {
      return ['Summer $year'] + common;
    } else if (month >= 5 && month < 8) {
      return ['Fall $year', 'Summer $year'] + common;
    } else if (month >= 8 && month < 11) {
      return ['Winter ${year + 1}', 'Fall $year', 'Summer $year'] + common;
    } else {
      return ['Spring ${year + 1}', 'Winter ${year + 1}', 'Fall $year', 'Summer $year'] + common;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> items = lastSeasons();
    for (int i = DateTime.now().year - 1; i >= 1917; i--) {
      items.addAll(['Fall $i', 'Summer $i', 'Spring $i', 'Winter $i']);
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
