import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'song_model.dart';
import 'song_detail_page.dart'; // Pastikan import ini benar

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late Box<Song> songBox;

  @override
  void initState() {
    super.initState();
    songBox = Hive.box<Song>('songsBox'); // Membuka box Hive
  }

  void _addNewSong() {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _artistController = TextEditingController();
    final TextEditingController _lyricsController = TextEditingController();
    final TextEditingController _interpretationController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.grey[900],
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add New Song',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              _buildTextField(_titleController, 'Title'),
              SizedBox(height: 15),
              _buildTextField(_artistController, 'Artist'),
              SizedBox(height: 15),
              _buildTextField(_lyricsController, 'Lyrics'),
              SizedBox(height: 15),
              _buildTextField(_interpretationController, 'Interpretation'),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel',
                        style:
                            TextStyle(color: Colors.redAccent, fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final newSong = Song(
                        title: _titleController.text,
                        artist: _artistController.text,
                        lyrics: _lyricsController.text,
                        interpretation: _interpretationController.text,
                      );

                      try {
                        await songBox.add(newSong); // Simpan lagu ke Hive
                        print('Song added successfully: ${newSong.title}');
                      } catch (e) {
                        print('Error adding song: $e');
                      }

                      Navigator.pop(context);
                      setState(() {}); // Refresh UI
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1DB954),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Add',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[800],
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.grey[900],
      ),
      body: ValueListenableBuilder(
        valueListenable: songBox.listenable(),
        builder: (context, Box<Song> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text(
                'No songs available. Add some!',
                style: TextStyle(color: Colors.grey[500], fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (ctx, index) {
              final song = box.getAt(index);
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                color: Colors.grey[850],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  title: Text(
                    song?.title ?? 'Unknown',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(song?.artist ?? 'Unknown',
                          style: TextStyle(color: Colors.grey[400])),
                      Text(
                        song?.interpretation ??
                            'No interpretation available',
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  onTap: () async {
                    final updatedSong = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => SongDetailPage(
                          song: song!,
                          onEditSong: (String id, Song updatedSong) {
                            songBox.putAt(index, updatedSong); // Update data di Hive
                            setState(() {});
                          },
                        ),
                      ),
                    );

                    if (updatedSong != null) {
                      setState(() {});
                    }
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () async {
                          final updatedSong = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => SongDetailPage(
                                song: song!,
                                onEditSong: (String id, Song updatedSong) {
                                  songBox.putAt(index, updatedSong); // Update di Hive
                                  setState(() {});
                                },
                              ),
                            ),
                          );

                          if (updatedSong != null) {
                            setState(() {});
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          box.deleteAt(index); // Hapus dari Hive
                          setState(() {}); // Refresh UI
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFF1DB954),
        icon: Icon(Icons.add),
        label: Text('New Song'),
        onPressed: _addNewSong,
      ),
    );
  }
}
