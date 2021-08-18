import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myanimelist/oauth.dart';

class AnimeDialog extends StatefulWidget {
  AnimeDialog(this.json);

  final Map<String, dynamic> json;

  @override
  _AnimeDialogState createState() => _AnimeDialogState();
}

class _AnimeDialogState extends State<AnimeDialog> {
  final List<String> _status = ['watching', 'completed', 'on_hold', 'dropped', 'plan_to_watch'];
  final List<String> _scores = ['0', '10', '9', '8', '7', '6', '5', '4', '3', '2', '1'];
  final TextEditingController _textFieldController = TextEditingController();
  String _selectedStatus;
  String _selectedScore;

  @override
  void initState() {
    super.initState();
    setState(() {
      _textFieldController.text = widget.json['num_episodes_watched'].toString();
      _selectedStatus = widget.json['status'] ?? 'watching';
      _selectedScore = widget.json['score'].toString();
    });
  }

  String statusText(String status) {
    switch (status) {
      case 'watching':
        return 'Watching';
        break;
      case 'completed':
        return 'Completed';
        break;
      case 'on_hold':
        return 'On-Hold';
        break;
      case 'dropped':
        return 'Dropped';
        break;
      case 'plan_to_watch':
        return 'Plan to Watch';
        break;
      default:
        throw 'AnimeStatus Error';
    }
  }

  String scoreText(String score) {
    switch (score) {
      case '10':
        return '(10) Masterpiece';
        break;
      case '9':
        return '(9) Great';
        break;
      case '8':
        return '(8) Very Good';
        break;
      case '7':
        return '(7) Good';
        break;
      case '6':
        return '(6) Fine';
        break;
      case '5':
        return '(5) Average';
        break;
      case '4':
        return '(4) Bad';
        break;
      case '3':
        return '(3) Very Bad';
        break;
      case '2':
        return '(2) Horrible';
        break;
      case '1':
        return '(1) Appalling';
        break;
      case '0':
        return 'Select';
        break;
      default:
        throw 'Score Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    String total = widget.json['total_episodes'] == 0 ? '?' : widget.json['total_episodes'].toString();
    return AlertDialog(
      title: Text('Edit Status'),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      content: Container(
        height: 150.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 48.0),
                  child: Text('Status:'),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedStatus,
                    items: _status.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(statusText(value)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == 'completed') _textFieldController.text = total;
                      setState(() => _selectedStatus = value);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 28.0),
                  child: Text('Eps Seen:'),
                ),
                Expanded(
                  child: TextField(
                    controller: _textFieldController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                Text(' / $total'),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: Theme.of(context).brightness == Brightness.light ? Colors.indigo : Colors.white,
                  ),
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
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text('Your Score:'),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text('Select'),
                    value: _selectedScore,
                    items: _scores.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(scoreText(value)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedScore = value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () async {
            final result = await MalClient().setStatus(
              widget.json['id'],
              status: _selectedStatus,
              score: _selectedScore,
              episodes: _textFieldController.text,
            );
            Navigator.of(context).pop(result);
          },
        ),
      ],
    );
  }
}
