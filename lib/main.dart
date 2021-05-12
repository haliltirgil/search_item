import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:search_screen/models/group.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Group> _groups = List<Group>();
  List<Group> _groupsForDisplay = List<Group>();

  Future<List<Group>> fetchGroups() async {
    var url = Uri.parse(
        "https://raw.githubusercontent.com/haliltirgil/json/main/random_example.json");
    var response = await http.get(url);

    var groups = List<Group>();

    if (response.statusCode == 200) {
      var groupsJson = json.decode(response.body);
      for (var noteJson in groupsJson) {
        groups.add(Group.fromJson(noteJson));
      }
    }
    return groups;
  }

  @override
  void initState() {
    fetchGroups().then((value) {
      setState(() {
        _groups.addAll(value);
        _groupsForDisplay = _groups;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Grup Arama'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildGroups(context),
            ],
          ),
        ));
  }

  Widget buildGroups(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        //itemExtent: 80,
        itemBuilder: (context, index) {
          return index == 0 ? searchBar() : listGroups(index - 1);
        },
        itemCount: _groupsForDisplay.length + 1,
      ),
    );
  }

  searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        margin: EdgeInsets.all(10),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: TextField(
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: 17),
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              hintText: 'Arama Yap...',
            ),
            onChanged: (text) {
              text = text.toLowerCase();
              setState(() {
                _groupsForDisplay = _groups.where((group) {
                  var groupTitle = group.name.toLowerCase();
                  return groupTitle.contains(text);
                }).toList();
              });
            },
          ),
        ),
      ),
    );
  }

  listGroups(index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      margin: EdgeInsets.only(left: 20, bottom: 10, right: 20),
      child: ListTile(
        onTap: () {},
        title: Text(_groupsForDisplay[index].name,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        subtitle: Text(
          _groupsForDisplay[index].numberOfUser,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        contentPadding: EdgeInsets.fromLTRB(25, 10, 0, 5),
      ),
    );
  }
}
