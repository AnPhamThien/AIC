import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:imagecaptioning/src/controller/notification/notification_bloc.dart';
import 'package:imagecaptioning/src/model/notification/notification.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';
import 'package:signalr_core/signalr_core.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listenWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
      listener: (context, state) {},
      child: Scaffold(
        appBar: getAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                List<NotificationItem>? notiList = state.notificationList;
                return Column(
                  children: [
                    getNotificationItem(
                        notiList?.first.imageUrl ?? 'assets/images/Veibae.jpeg',
                        notiList?.first.userName,
                        notiList?.first.notifyContent ?? '',
                        notiList?.first.totalHours?.toInt() ?? 0),
                    getNotificationItem("assets/images/Veibae.jpeg", "Veibae",
                        "Đã bình luận vào bài viết của bạn", 15),
                    getNotificationItem("assets/images/Gumba.jpg", "Gumba",
                        "Đã theo dõi bạn", 15),
                    getNotificationItem("assets/images/Gumba.jpg", "Gumba",
                        "Đã theo dõi bạn", 15),
                    getNotificationItem("assets/images/Gumba.jpg", "Gumba",
                        "Đã theo dõi bạn", 15),
                    getNotificationItem("assets/images/Gumba.jpg", "Gumba",
                        "Đã theo dõi bạn", 15),
                    getNotificationItem("assets/images/Gumba.jpg", "Gumba",
                        "Đã theo dõi bạn", 15),
                    getNotificationItem("assets/images/Gumba.jpg", "Gumba",
                        "Đã theo dõi bạn", 15),
                    getNotificationItem("assets/images/Gumba.jpg", "Gumba",
                        "Đã theo dõi bạn", 15),
                    getNotificationItem("assets/images/Gumba.jpg", "Gumba",
                        "Đã theo dõi bạn", 15),
                    getNotificationItem("assets/images/Gumba.jpg", "Gumba",
                        "Đã theo dõi bạn", 15),
                    getNotificationItem("assets/images/Gumba.jpg", "Gumba",
                        "Đã theo dõi bạn", 15),
                    getNotificationItem("assets/images/Gumba.jpg", "Gumba",
                        "Đã theo dõi bạn", 15),
                    getNotificationItem("assets/images/Gumba.jpg", "Gumba",
                        "Đã theo dõi bạn", 15),
                    getNotificationItem("assets/images/WTF.jpg", "",
                        "1 bài viết của bạn đã bị xóa", 15),
                  ],
                );
              },
            ),
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
