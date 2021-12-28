import 'package:flutter/material.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: getAppBar(
          "assets/images/Kroni.jpg",
          "Kronii",
          "Ouro_Kronii",
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                getMessageItem(false, "Hi!"),
                getMessageItem(true, "Hello!"),
                getMessageItem(false, "How are you?"),
                getMessageItem(true, "Oh, I'm fine"),
                getMessageItem(true, "I'm going to make some breakfast, you ?"),
                getMessageItem(false,
                    "I'm eating right now ;)\nIt's Bacon, egg and toast but i but some effort and including the cheese!"),
                getMessageItem(true, "Nice!"),
                getMessageItem(true, "Hello!"),
                getMessageItem(true, "Hello!"),
                getMessageItem(true, "Hello!"),
                getMessageItem(true, "Hello!"),
                getMessageItem(true, "Hello!"),
                getMessageItem(true, "Hello!"),
                getMessageItem(true, "Hello!"),
                getMessageItem(true, "Hello!"),
                getMessageItem(true, "Hello!"),
                getMessageItem(true, "Hello!"),
                getMessageItem(true, "Hello!"),
                getMessageItem(true, "Hello!"),
                getMessageItem(true, "Hello!"),
                getMessageItem(true, "Hello!"),
              ],
            ),
          ),
        ),
        bottomNavigationBar: getMessageBottomBar(),
      ),
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
                image: AssetImage(img),
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
