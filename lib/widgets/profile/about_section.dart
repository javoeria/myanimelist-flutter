import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  AboutSection(this.about);

  final String? about;
  final RegExp exp = RegExp(r'<[^>]*>|\\n', multiLine: true, caseSensitive: true);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('About', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16.0),
          Text(about != null ? about!.replaceAll(exp, '').trim() : '(No biography written.)', softWrap: true),
        ],
      ),
    );
  }
}
