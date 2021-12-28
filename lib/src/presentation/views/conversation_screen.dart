import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constanct/env.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';
import 'package:imagecaptioning/src/controller/conversation/conversation_bloc.dart';
import 'package:imagecaptioning/src/model/conversation/conversation.dart';
import 'package:imagecaptioning/src/presentation/views/message_screen.dart';
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
  final SignalRHelper _signalRHelper = SignalRHelper();

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
    super.dispose();
  }

  void _onScroll() {
    if (isScrollEnd(_scrollController)) {
      log("Fetchmore");
      context.read<ConversationBloc>().add(FetchConversation());
    }
  }

  @override
  Widget build(BuildContext context) {
    String username = "thieen_aan";
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: username),
        elevation: 0,
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: BlocBuilder<ConversationBloc, ConversationState>(
          builder: (context, state) {
            List<Conversation>? conversationList = state.conversationList;
            if (conversationList != null) {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  final Conversation conversation = conversationList[index];
                  return getConversationItem(
                      conversation.isSeen == 1,
                      conversation.avataUrl ?? '',
                      conversation.userName,
                      conversation.messageContent,
                      conversation.totalTime!.toInt());
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
    );
  }

  ListTile getConversationItem(
      bool isNew, String img, username, message, int time) {
    return ListTile(
      onTap: () {
        context
            .read<AuthBloc>()
            .add(NavigateToPageEvent(route: AppRouter.editProfileScreen));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ConversationScreen(),
          ),
        );
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
        time.toString() + " min",
        style: TextStyle(
          fontWeight: isNew ? FontWeight.bold : null,
          color: isNew ? Colors.black : null,
        ),
      ),
    );
  }
}
