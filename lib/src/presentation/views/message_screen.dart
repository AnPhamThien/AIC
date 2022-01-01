import 'dart:developer';

import 'package:flutter/material.dart';
import '../../constanct/env.dart';
import '../../controller/auth/auth_bloc.dart';
import '../../controller/get_it/get_it.dart';
import '../../controller/message/message_bloc.dart';
import '../../model/conversation/message.dart';
import '../../prefs/app_prefs.dart';
import '../theme/style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../signalr/signalr_helper.dart';
import '../../utils/func.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _scrollController = ScrollController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    registerGetMessages();
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
      //context.read<MessageBloc>().add(FetchMessage());
    }
  }

  void registerGetMessages() {
    if (SignalRHelper.hubConnection != null) {
      SignalRHelper.hubConnection!
          .on('specificnotification', _handleGetMessage);
    }
  }

  void _handleGetMessage(List<dynamic>? parameters) {
    context.read<MessageBloc>().add(FetchMoreMessage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, state) {
        List<Message>? notiList = state.messageList;
        return Scaffold(
            body: Scaffold(
          appBar: getAppBar(
            state.avatar ?? '',
            state.userRealName ?? state.username ?? '',
            state.username ?? '',
          ),
          body: SafeArea(
            child: notiList != null
                ? ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      final Message noti = notiList[index];
                      log(noti.userId.toString());
                      log(getIt<AppPref>().getUserID);
                      return getMessageItem(
                          noti.userId == getIt<AppPref>().getUserID,
                          noti.content ?? '');
                    },
                    itemCount: state.messageList?.length,
                    controller: _scrollController,
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          bottomNavigationBar: getMessageBottomBar(),
        ));
      },
    );
  }

  Row getMessageItem(bool isSelf, String message) {
    return Row(
      mainAxisAlignment:
          isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .6, minWidth: 0),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
            decoration: BoxDecoration(
              color: isSelf ? bgGrey.withOpacity(.75) : bgApp,
              borderRadius: const BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Container getMessageBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: const BoxDecoration(
        color: bgApp,
        borderRadius: BorderRadius.all(Radius.circular(45)),
      ),
      child: TextField(
        controller: _messageController,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: -3),
          hintText: 'Message ..',
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.send,
              size: 25.0,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  AppBar getAppBar(String img, name, username) {
    return AppBar(
      titleSpacing: 0,
      elevation: 0,
      title: ListTile(
        onTap: () {},
        contentPadding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
        leading: SizedBox(
          child: CircleAvatar(
            child: ClipOval(
              child: Image(
                height: 60.0,
                width: 60.0,
                image: (img.isNotEmpty)
                    ? NetworkImage(avatarUrl + img)
                    : const AssetImage('assets/images/Kroni.jpg')
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          username,
          style: const TextStyle(
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
          softWrap: true,
        ),
      ),
    );
  }
}
