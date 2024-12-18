import 'package:flutter/material.dart';
import 'song_model.dart';

class SongDetailPage extends StatelessWidget {
  final Song song;
  final Function(String, Song) onEditSong;

  SongDetailPage({required this.song, required this.onEditSong});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _lyricsController =
        TextEditingController(text: song.lyrics);
    final TextEditingController _interpretationController =
        TextEditingController(text: song.interpretation);

    void _saveChanges() {
      final updatedSong = Song(
        title: song.title,
        artist: song.artist,
        lyrics: _lyricsController.text,
        interpretation: _interpretationController.text,
      );
      onEditSong(song.key, updatedSong); // Gunakan Hive key untuk identifikasi
      Navigator.pop(context, updatedSong);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(song.title, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Lyrics'),
            SizedBox(height: 8),
            _buildTextField(_lyricsController, 'Edit Lyrics'),
            SizedBox(height: 20),
            _buildSectionTitle('Interpretation'),
            SizedBox(height: 8),
            _buildTextField(_interpretationController, 'Edit Interpretation'),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton.icon(
                onPressed: _saveChanges,
                icon: Icon(Icons.check, size: 20),
                label: Text('Save Changes', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1DB954),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      maxLines: 5,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

