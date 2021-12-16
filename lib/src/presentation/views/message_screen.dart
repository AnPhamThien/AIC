import 'package:flutter/material.dart';
import 'package:imagecaptioning/src/presentation/views/conversation_screen.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              getMessageItem(false, "assets/images/Kroni.jpg", "Kronii",
                  "Kronichiwa !", 5),
              getMessageItem(true, "assets/images/Kroni.jpg", "Kronii",
                  "Kronichiwa !, watashi wa Kronii desu", 5),
              getMessageItem(false, "assets/images/Kroni.jpg", "Kronii",
                  "Kronichiwa !", 5),
              getMessageItem(false, "assets/images/Kroni.jpg", "Kronii",
                  "Kronichiwa !", 5),
              getMessageItem(false, "assets/images/Kroni.jpg", "Kronii",
                  "Kronichiwa !", 5),
              getMessageItem(false, "assets/images/Kroni.jpg", "Kronii",
                  "Kronichiwa !", 5),
              getMessageItem(false, "assets/images/Kroni.jpg", "Kronii",
                  "Kronichiwa !", 5),
              getMessageItem(false, "assets/images/Kroni.jpg", "Kronii",
                  "Kronichiwa !", 5),
              getMessageItem(false, "assets/images/Kroni.jpg", "Kronii",
                  "Kronichiwa !", 5),
              getMessageItem(false, "assets/images/Kroni.jpg", "Kronii",
                  "Kronichiwa !", 5),
              getMessageItem(false, "assets/images/Kroni.jpg", "Kronii",
                  "Kronichiwa !", 5),
              getMessageItem(false, "assets/images/Kroni.jpg", "Kronii",
                  "Kronichiwa !", 5),
              getMessageItem(false, "assets/images/Kroni.jpg", "Kronii",
                  "Kronichiwa !", 5),
              getMessageItem(false, "assets/images/Kroni.jpg", "Kronii",
                  "Kronichiwa !", 5),
            ],
          ),
        ),
      ),
    );
  }

  ListTile getMessageItem(bool isNew, String img, username, message, int time) {
    return ListTile(
      onTap: () {
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
              image: AssetImage(img),
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
