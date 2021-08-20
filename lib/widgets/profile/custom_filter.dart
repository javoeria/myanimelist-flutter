import 'package:flutter/material.dart';
import 'package:myanimelist/models/user_list.dart';
import 'package:myanimelist/screens/anime_list_screen.dart';
import 'package:myanimelist/screens/manga_list_screen.dart';
import 'package:provider/provider.dart';

class CustomFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.filter_list),
      onPressed: () {
        var json = Provider.of<UserList>(context, listen: false).toJson();
        showDialog<void>(
          context: context,
          builder: (context) => FilterDialog(json),
        );
      },
    );
  }
}

class FilterDialog extends StatefulWidget {
  FilterDialog(this.json);

  final Map<String, String?> json;

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final List<String> _orders = ['title', 'score', 'type', 'progress'];
  final TextEditingController _textFieldController = TextEditingController();
  String? _selectedOrder;
  String? _selectedSort;

  @override
  void initState() {
    super.initState();
    setState(() {
      _textFieldController.text = widget.json['query'] ?? '';
      _selectedOrder = widget.json['order'];
      _selectedSort = widget.json['sort'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter'),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      content: Container(
        height: 150.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.search),
                ),
                Expanded(
                  child: TextField(
                    autofocus: false,
                    controller: _textFieldController,
                    decoration: InputDecoration(hintText: 'Title'),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.sort),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text('Order'),
                    value: _selectedOrder,
                    items: _orders.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text('Order by ${value[0].toUpperCase()}${value.substring(1)}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedOrder = value!;
                        if (_selectedSort == null) _selectedSort = 'desc';
                      });
                    },
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.import_export),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text('Sort'),
                    value: _selectedSort,
                    items: ['desc', 'asc'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: value == 'desc' ? Text('Descending') : Text('Ascending'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSort = value!;
                      });
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('CLEAR'),
          onPressed: () {
            Navigator.pop(context);
            if (widget.json['type'] == 'anime') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimeListScreen(widget.json['username']!),
                  settings: RouteSettings(name: 'AnimeListScreen'),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MangaListScreen(widget.json['username']!),
                  settings: RouteSettings(name: 'MangaListScreen'),
                ),
              );
            }
          },
        ),
        TextButton(
          child: Text('APPLY'),
          onPressed: () {
            Navigator.pop(context);
            if (widget.json['type'] == 'anime') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimeListScreen(
                    widget.json['username']!,
                    title: _textFieldController.text,
                    order: _selectedOrder,
                    sort: _selectedSort,
                  ),
                  settings: RouteSettings(name: 'AnimeListScreen'),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MangaListScreen(
                    widget.json['username']!,
                    title: _textFieldController.text,
                    order: _selectedOrder,
                    sort: _selectedSort,
                  ),
                  settings: RouteSettings(name: 'MangaListScreen'),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
