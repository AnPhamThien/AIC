import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/controller/message/message_bloc.dart';
import 'package:imagecaptioning/src/model/conversation/message.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/signalr/signalr_helper.dart';
import 'package:imagecaptioning/src/utils/func.dart';

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
    super.initState();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    SignalRHelper.messageContext = null;
    super.dispose();
  }

  void _onScroll() {
    if (isScrollEnd(_scrollController)) {
      context.read<MessageBloc>().add(FetchMoreMessage());
    }
  }

  void invokeSendMessage(List<dynamic>? args) async {
    try {
      if (SignalRHelper.hubConnection != null) {
        final result = await SignalRHelper.hubConnection
            ?.invoke("SendPrivate", args: args);
        log("Result: '$result");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, state) {
        SignalRHelper.messageContext = context;
        List<Message>? messageList = state.messageList;
        return Scaffold(
            body: Scaffold(
          appBar: getAppBar(
            state.avatar ?? '',
            state.userRealName ?? state.username ?? '',
            state.username ?? '',
          ),
          body: SafeArea(
            child: messageList != null
                ? ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      final Message message = messageList[index];
                      return getMessageItem(
                          message.userId == getIt<AppPref>().getUserID,
                          message.content ?? '');
                    },
                    itemCount: state.messageList?.length,
                    controller: _scrollController,
                    reverse: true,
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
            onPressed: () {
              List<dynamic> args = [];
              args.add(_messageController.value.text);
              args.add(context.read<MessageBloc>().state.userId);
              invokeSendMessage(args);
              _messageController.clear();
              FocusScope.of(context).unfocus();
            },
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
                    : const AssetImage('assets/images/avatar_placeholder.png')
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
