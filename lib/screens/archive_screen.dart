import 'package:flutter/material.dart';

class ArchiveScreen extends StatelessWidget {
  List<String> lastSeasons() {
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    List<String> common = ['Summer $year', 'Spring $year', 'Winter $year'];
    if (month < 4) {
      return common;
    } else if (month >= 4 && month < 7) {
      return ['Fall $year'] + common;
    } else if (month >= 7 && month < 10) {
      return ['Winter ${year + 1}', 'Fall $year'] + common;
    } else {
      return ['Spring ${year + 1}', 'Winter ${year + 1}', 'Fall $year'] + common;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> archive = lastSeasons();
    for (int i = DateTime.now().year - 1; i >= 1917; i--) {
      archive.addAll(['Fall $i', 'Summer $i', 'Spring $i', 'Winter $i']);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Archive')),
      body: Scrollbar(
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(height: 0.0),
          itemCount: archive.length,
          itemBuilder: (context, index) {
            String season = archive.elementAt(index);
            return ListTile(
              title: Text(season),
              onTap: () => Navigator.pop(context, season),
            );
          },
        ),
      ),
    );
  }
}
