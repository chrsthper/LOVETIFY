import 'package:hive/hive.dart';

part 'song_model.g.dart';

@HiveType(typeId: 0) // Pastikan typeId ini unik
class Song extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String artist;

  @HiveField(2)
  final String lyrics; // Tambahkan lyrics

  @HiveField(3)
  final String interpretation; // Tambahkan interpretation

  Song({
    required this.title,
    required this.artist,
    required this.lyrics,
    required this.interpretation,
  });

  // Metode toJson untuk debugging
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'lyrics': lyrics,
      'interpretation': interpretation,
    };
  }
}
