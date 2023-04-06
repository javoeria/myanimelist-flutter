import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  AboutSection(this.about);

  final String? about;
  final RegExp exp = RegExp(r"(<[^>]*>)|(\\n)", multiLine: true, caseSensitive: true);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('About', style: Theme.of(context).textTheme.titleMedium),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Text(about != null ? about!.replaceAll(exp, '') : '(No biography written.)', softWrap: true),
        ),
      ],
    );
  }
}
