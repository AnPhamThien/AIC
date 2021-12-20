import 'package:flutter/material.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              getNotificationItem("assets/images/JOKERONI.jpg", "Kronii",
                  "đã thích bài viết của bạn", 15),
              getNotificationItem("assets/images/Veibae.jpeg", "Veibae",
                  "Đã bình luận vào bài viết của bạn", 15),
              getNotificationItem(
                  "assets/images/Gumba.jpg", "Gumba", "Đã theo dõi bạn", 15),
              getNotificationItem(
                  "assets/images/Gumba.jpg", "Gumba", "Đã theo dõi bạn", 15),
              getNotificationItem(
                  "assets/images/Gumba.jpg", "Gumba", "Đã theo dõi bạn", 15),
              getNotificationItem(
                  "assets/images/Gumba.jpg", "Gumba", "Đã theo dõi bạn", 15),
              getNotificationItem(
                  "assets/images/Gumba.jpg", "Gumba", "Đã theo dõi bạn", 15),
              getNotificationItem(
                  "assets/images/Gumba.jpg", "Gumba", "Đã theo dõi bạn", 15),
              getNotificationItem(
                  "assets/images/Gumba.jpg", "Gumba", "Đã theo dõi bạn", 15),
              getNotificationItem(
                  "assets/images/Gumba.jpg", "Gumba", "Đã theo dõi bạn", 15),
              getNotificationItem(
                  "assets/images/Gumba.jpg", "Gumba", "Đã theo dõi bạn", 15),
              getNotificationItem(
                  "assets/images/Gumba.jpg", "Gumba", "Đã theo dõi bạn", 15),
              getNotificationItem(
                  "assets/images/Gumba.jpg", "Gumba", "Đã theo dõi bạn", 15),
              getNotificationItem(
                  "assets/images/Gumba.jpg", "Gumba", "Đã theo dõi bạn", 15),
              getNotificationItem("assets/images/WTF.jpg", "",
                  "1 bài viết của bạn đã bị xóa", 15),
            ],
          ),
        ),
      ),
    );
  }

  ListTile getNotificationItem(
      String imgLink, String? username, String context, int time) {
    return ListTile(
      leading: SizedBox(
        width: 45.0,
        height: 45.0,
        child: CircleAvatar(
          child: ClipOval(
            child: Image(
              height: 45.0,
              width: 45.0,
              image: AssetImage(imgLink),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      //isThreeLine: true,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: username ?? "",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            TextSpan(
              text: " " + context,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      subtitle: Text(time.toString() + " min"),
    );
  }

  AppBar getAppBar() {
    return AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const AppBarTitle(title: "Notification"));
  }
}
