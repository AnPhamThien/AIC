import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';
import 'package:imagecaptioning/src/controller/conversation/conversation_bloc.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/model/conversation/conversation.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';
import 'package:imagecaptioning/src/signalr/signalr_helper.dart';
import 'package:imagecaptioning/src/utils/func.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _scrollController = ScrollController();

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
    SignalRHelper.conversationContext = null;
    super.dispose();
  }

  void _onScroll() {
    if (isScrollEnd(_scrollController)) {
      log("Fetchmore");
      context.read<ConversationBloc>().add(FetchMoreConversation());
    }
  }

  @override
  Widget build(BuildContext context) {
    String username = getIt<AppPref>().getUsername;
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: username),
        elevation: 0,
        titleSpacing: 0,
      ),
      body: BlocListener<ConversationBloc, ConversationState>(
        listener: (context, state) {},
        child: SafeArea(
          child: BlocBuilder<ConversationBloc, ConversationState>(
            builder: (context, state) {
              SignalRHelper.conversationContext = context;
              List<Conversation>? conversationList = state.conversationList;
              if (conversationList != null) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    final Conversation conversation = conversationList[index];
                    return getConversationItem(
                        conversation.sendUserId == getIt<AppPref>().getUserID
                            ? false
                            : conversation.isSeen == 0,
                        conversation.avataUrl ?? '',
                        conversation.userName,
                        conversation.messageContent,
                        timeCalculateDouble(conversation.totalTime ?? 0),
                        conversation.conversationId,
                        conversation.userRealName,
                        conversation.userId);
                  },
                  itemCount: state.conversationList?.length,
                  controller: _scrollController,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  ListTile getConversationItem(bool isNew, String img, username, message,
      String time, conversationId, userRealName, otherUserId) {
    return ListTile(
      onTap: () {
        Map<String, dynamic> args = {
          "username": username,
          "avatar": img,
          "conversationId": conversationId,
          "userRealName": userRealName,
          "otherUserId": otherUserId
        };
        context.read<AuthBloc>().add(
            NavigateToPageEvent(route: AppRouter.messageScreen, args: args));
      },
      onLongPress: () {},
      contentPadding: const EdgeInsets.fromLTRB(15, 10, 20, 10),
      leading: SizedBox(
        width: 60.0,
        height: 60.0,
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
        username,
        style: TextStyle(
          fontSize: 18,
          fontWeight: isNew ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      subtitle: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          overflow: TextOverflow.ellipsis,
          fontWeight: isNew ? FontWeight.bold : null,
          color: isNew ? Colors.black : null,
        ),
        maxLines: 1,
        softWrap: true,
      ),
      trailing: Text(
        time,
        style: TextStyle(
          fontWeight: isNew ? FontWeight.bold : null,
          color: isNew ? Colors.black : null,
        ),
      ),
    );
  }
}
