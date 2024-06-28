import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Input_Pemain.dart';
import 'edit_pemain.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => PlayerList(),
        '/input': (context) => InputPlayer(),
      },
    );
  }
}

class PlayerList extends StatefulWidget {
  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  List players = [];
  Map<String, List> teams = {};

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  fetchPlayers() async {
    final response =
        await http.get(Uri.parse('http://localhost/tampil_pemain.php'));
    if (response.statusCode == 200) {
      setState(() {
        players = json.decode(response.body);
        groupPlayersByTeam();
      });
    } else {
      throw Exception('Failed to load players');
    }
  }

  groupPlayersByTeam() {
    teams = {};
    for (var player in players) {
      String team = player['tim'];
      if (teams.containsKey(team)) {
        teams[team]!.add(player);
      } else {
        teams[team] = [player];
      }
    }
  }

  deletePlayer(String id) async {
    final response = await http.post(
      Uri.parse('http://localhost/hapus_pemain.php'),
      body: {'id': id},
    );

    if (response.statusCode == 200) {
      fetchPlayers(); // Refresh the list
    } else {
      throw Exception('Failed to delete player');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pemain E-Sport'),
        backgroundColor: Color(0xFF690006),
      ),
      body: Container(
        color: Color(0xFF121212),
        child: players.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  String teamName = teams.keys.elementAt(index);
                  List teamPlayers = teams[teamName]!;
                  return Card(
                    color: Color(0xFF646464),
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            teamName,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(
                                    label: Text('Player',
                                        style: TextStyle(color: Colors.white))),
                                DataColumn(
                                    label: Text('Country',
                                        style: TextStyle(color: Colors.white))),
                                DataColumn(label: Text(' ')),
                              ],
                              rows: teamPlayers.map((player) {
                                return DataRow(cells: [
                                  DataCell(Text(player['nama'],
                                      style: TextStyle(color: Colors.white))),
                                  DataCell(Text(player['negara'],
                                      style: TextStyle(color: Colors.white))),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors.white),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditPlayer(player: player),
                                              ),
                                            ).then((value) => fetchPlayers());
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.white),
                                          onPressed: () {
                                            deletePlayer(player['id']);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/input')
              .then((value) => fetchPlayers());
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah',
        backgroundColor: Color(0xFF690006),
      ),
    );
  }
}
