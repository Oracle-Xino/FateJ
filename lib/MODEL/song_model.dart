class SongModel {
  final int? id;
  final String? title;
  final String? songSource;
  final String? image;

  const SongModel({this.id, this.title, this.songSource, this.image});

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'songSource': songSource,
    'image': image,
  };

  factory SongModel.toDart(Map<String, dynamic> map) => SongModel(
    id: map['id'],
    title: map['title'],
    songSource: map['songSource'],
    image: map['image'],
  );

  SongModel copySong({
    int? id,
    String? title,
    String? songSource,
    String? image,
  }) => SongModel(
    id: id ?? this.id,
    title: title ?? this.title,
    songSource: songSource ?? this.songSource,
    image: image ?? this.image,
  );
}

List<SongModel> systemSong = [
  // SongModel(
  //   id: 1,
  //   title: 'Pegadora/Guitar',
  //   songSource: 'assets/songs/Pegadora_Guitar.mp3',
  //   image:
  //       'https://i.pinimg.com/736x/32/ab/77/32ab77197f4fe3e6a99219a09f775de5.jpg',
  // ),
  // SongModel(
  //   id: 2,
  //   title: 'Letal/Guitar',
  //   songSource: 'assets/songs/Letal Guitar.mp3',
  //   image:
  //       'https://i.pinimg.com/1200x/95/40/db/9540db4c5f1eae5076aa7b0fdd38fa2a.jpg',
  // ),
  // SongModel(
  //   id: 3,
  //   title: 'Damage-Ascension/Guitar',
  //   songSource: 'assets/songs/Damage Ascension Guitar.mp3',
  //   image:
  //       'https://i.pinimg.com/736x/c3/31/f2/c331f2be87279af277b5428c18b11222.jpg',
  // ),
  // SongModel(
  //   id: 4,
  //   title: 'Montagem/Guitar',
  //   songSource: 'assets/songs/Montagem Guitar.mp3',
  //   image:
  //       'https://i.pinimg.com/736x/9d/61/2a/9d612a3605a71d51fe58abcbbb1dd453.jpg',
  // ),

  // SongModel(
  //   id: 5,
  //   title: 'Jessie',
  //   songSource: 'assets/songs/jessie_riserayss.mp3',
  //   image:
  //       'https://cdn-images.dzcdn.net/images/cover/7fc44d9ca8313f3f7a33a1a8e09b948f/1900x1900-000000-80-0-0.jpg',
  // ),
  // SongModel(
  //   id: 6,
  //   title: 'Skins',
  //   songSource: 'assets/songs/Skins_KREZUS.mp3',
  //   image:
  //       'https://i.pinimg.com/control1/736x/f0/dd/f4/f0ddf404c6a5d637b029a123b5de3dea.jpg',
  // ),
  // SongModel(
  //   id: 7,
  //   title: 'Starly',
  //   songSource: 'assets/songs/starly_LONOWN.mp3',
  //   image:
  //       'https://i.pinimg.com/736x/9c/66/92/9c6692fdb70b2a920c86cd4576419ae1.jpg',
  // ),
  // SongModel(
  //   id: 8,
  //   title: 'In and Out of Love x Vanguard',
  //   songSource: 'assets/songs/in_out_x_Vanguard.mp3',
  //   image:
  //       'https://i.pinimg.com/736x/1c/7e/e6/1c7ee6d8fec3c9fee7499f93441b3e1c.jpg',
  // ),
  // SongModel(
  //   id: 9,
  //   title: 'Starly',
  //   songSource: 'assets/songs/STRUCT_UdieNnx.mp3',
  //   image:
  //       'https://i.pinimg.com/736x/21/68/98/21689841b8dcd91e219de0a98a96b30d.jpg',
  // ),
  // SongModel(
  //   id: 10,
  //   title: 'សុំជួបអូនមួយម៉ោងមុនពេលបែកគ្នា',
  //   songSource: 'assets/songs/1hour.mp3',
  //   image:
  //       'https://i.pinimg.com/control1/1200x/f2/a1/6a/f2a16af0f1747b676e05609a02c47c96.jpg',
  // ),
];
