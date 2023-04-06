import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/oauth.dart';

class MangaDialog extends StatefulWidget {
  const MangaDialog(this.json);

  final Map<String, dynamic> json;

  @override
  _MangaDialogState createState() => _MangaDialogState();
}

class _MangaDialogState extends State<MangaDialog> {
  final List<String> _status = ['reading', 'completed', 'on_hold', 'dropped', 'plan_to_read'];
  final List<String> _scores = ['0', '10', '9', '8', '7', '6', '5', '4', '3', '2', '1'];
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();
  late String _selectedStatus;
  late String _selectedScore;

  @override
  void initState() {
    super.initState();
    setState(() {
      _textFieldController.text = widget.json['num_chapters_read'].toString();
      _textFieldController2.text = widget.json['num_volumes_read'].toString();
      _selectedStatus = widget.json['status'] ?? 'reading';
      _selectedScore = widget.json['score'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    String total = widget.json['total_chapters'] == 0 ? '?' : widget.json['total_chapters'].toString();
    String total2 = widget.json['total_volumes'] == 0 ? '?' : widget.json['total_volumes'].toString();
    return AlertDialog(
      title: Text('Edit Status'),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
      content: SingleChildScrollView(
        child: Column(
          children: <Row>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 44.0),
                  child: Text('Status:'),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedStatus,
                    items: _status.map((value) {
                      return DropdownMenuItem(value: value, child: Text(statusText(value)));
                    }).toList(),
                    onChanged: (value) {
                      if (value == 'completed') {
                        _textFieldController.text = total;
                        _textFieldController2.text = total2;
                      }
                      setState(() => _selectedStatus = value!);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text('Chap. Read:'),
                ),
                Expanded(
                  child: TextField(
                    controller: _textFieldController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                Text(' / $total'),
                IconButton(
                  icon: Icon(Icons.add_circle_rounded),
                  onPressed: () {
                    if (_textFieldController.text.isEmpty) {
                      _textFieldController.text = '0';
                    } else if (total == '?' || int.parse(_textFieldController.text) < int.parse(total)) {
                      _textFieldController.text = (int.parse(_textFieldController.text) + 1).toString();
                    }
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: Text('Vol. Read:'),
                ),
                Expanded(
                  child: TextField(
                    controller: _textFieldController2,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                Text(' / $total2'),
                IconButton(
                  icon: Icon(Icons.add_circle_rounded),
                  onPressed: () {
                    if (_textFieldController2.text.isEmpty) {
                      _textFieldController2.text = '0';
                    } else if (total2 == '?' || int.parse(_textFieldController2.text) < int.parse(total2)) {
                      _textFieldController2.text = (int.parse(_textFieldController2.text) + 1).toString();
                    }
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text('Your Score:'),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text('Select'),
                    value: _selectedScore,
                    items: _scores.map((value) {
                      return DropdownMenuItem(value: value, child: Text(scoreText(value)));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedScore = value!),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <TextButton>[
        TextButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () async {
            final result = await MalClient().setStatus(
              widget.json['id'],
              anime: false,
              status: _selectedStatus,
              score: _selectedScore,
              chapters: _textFieldController.text,
              volumes: _textFieldController2.text,
            );
            Navigator.pop(context, result);
          },
        ),
      ],
    );
  }
}
