

class User {
  //TODO mốt bỏ cái này nè
  final String img;
  final String userName;
  final String userRealName;

  User(this.img, this.userName, this.userRealName);

  static List<User> getSearchedUser() {
    return [
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
      User("assets/images/Kroni.jpg", "Kroni", "OuroKroni"),
    ];
  }
}

class Contest {
  final String contestName;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final int statusCode;

  Contest(this.contestName, this.startDate, this.endDate, this.description,
      this.statusCode);

  static List<Contest> getContestList() {
    return [
      Contest(
          "Little place, Big taste!",
          DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 31),
          "Nhưng quán ăn ngon nơi hàng quán nhỏ",
          3),
      Contest(
          "Little place, Big taste!",
          DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 31),
          "Nhưng quán ăn ngon nơi hàng quán nhỏ",
          3),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
      Contest("Cà phê và những ngày mưa", DateTime.utc(2020, 1, 1),
          DateTime.utc(2020, 12, 12), "Cà phê, thuốc lá và những ngày mưa", 4),
    ];
  }
}

class Post {
  final String postAvatar;
  final String postUsername;
  final int postTime;
  final String postImage;
  final int postLikeCount;
  final int postCommentCount;
  final String postCaption;

  Post(this.postAvatar, this.postUsername, this.postTime, this.postImage,
      this.postLikeCount, this.postCommentCount, this.postCaption);

  static List<Post> getPostList() {
    return [
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "WTF?"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15,
          "assets/images/Gumba.jpg", 2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
      Post("assets/images/Kroni.jpg", "thieen_aan", 15, "assets/images/WTF.jpg",
          2109, 170, "Help, I'm Tired !"),
    ];
  }
}

class Album {
  final String albumName;
  List<String> albumImages;

  Album(this.albumName, this.albumImages);

  static List<Album> getAlbumList() {
    String source = "assets/images/";
    return [
      Album(
        'Default Album',
        [
          source + "Kronicopter.jpg",
          source + "JOKERONI.jpg",
          source + "Gumba.jpg",
          source + "Kronicopter.jpg",
          source + "padoru.jpg",
          source + "Whut.jpg",
        ],
      ),
      Album(
        'New Album',
        [
          source + "JOKERONI.jpg",
          source + "Kronicopter.jpg",
          source + "Gumba.jpg",
          source + "Kronicopter.jpg",
          source + "padoru.jpg",
          source + "Whut.jpg",
        ],
      ),
      Album(
        'Food Album',
        [],
      ),
      Album(
        'Christmassss',
        [
          source + "padoru.jpg",
          source + "Kronicopter.jpg",
          source + "JOKERONI.jpg",
          source + "Gumba.jpg",
          source + "Kronicopter.jpg",
          source + "padoru.jpg",
          source + "Whut.jpg",
        ],
      ),
      Album(
        'Mood Album',
        [
          source + "Gumba.jpg",
          source + "Whut.jpg",
          source + "Kronicopter.jpg",
          source + "JOKERONI.jpg",
          source + "Gumba.jpg",
          source + "Kronicopter.jpg",
          source + "padoru.jpg",
          source + "Whut.jpg",
        ],
      ),
    ];
  }
}
