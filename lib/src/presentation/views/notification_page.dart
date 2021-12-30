import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/constanct/env.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';

import 'package:imagecaptioning/src/controller/notification/notification_bloc.dart';
import 'package:imagecaptioning/src/model/notification/notification.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';
import 'package:imagecaptioning/src/signalr/signalr_helper.dart';
import 'package:imagecaptioning/src/utils/func.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _scrollController = ScrollController();
  final SignalRHelper _signalRHelper = SignalRHelper();

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    registerSpecificNotification();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (isScrollEnd(_scrollController)) {
      log("Fetchmore");
      context.read<NotificationBloc>().add(FetchNotification());
    }
  }

  void registerSpecificNotification() {
    if (SignalRHelper.hubConnection != null) {
      SignalRHelper.hubConnection!
          .on('specificnotification', _handleSpecificNotification);
    }
  }

  void _handleSpecificNotification(List<dynamic>? parameters) {
    context.read<NotificationBloc>().add(FetchNotification());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.reconnected) {
          log("registerSpecific");
          registerSpecificNotification();
          context.read<AuthBloc>().add(FinishReconnectEvent());
        }
      },
      child: BlocListener<NotificationBloc, NotificationState>(
        listenWhen: (previous, current) =>
            previous.formStatus != current.formStatus,
        listener: (context, state) {},
        child: Scaffold(
          appBar: getAppBar(),
          body: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  List<NotificationItem>? notiList = state.notificationList;
                  if (notiList != null) {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        final NotificationItem noti = notiList[index];
                        return getNotificationItem(
                            noti.imageUrl ?? '',
                            noti.userName,
                            noti.notifyContent ?? '',
                            noti.totalHours?.toInt() ?? 0);
                      },
                      itemCount: state.notificationList?.length,
                      controller: _scrollController,
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
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
              image: (imgLink.isNotEmpty)
                  ? NetworkImage(postImageUrl + imgLink)
                  : const AssetImage('assets/images/Veibae.jpeg')
                      as ImageProvider,
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
