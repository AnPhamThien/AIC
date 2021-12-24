import 'package:flutter/material.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/widgets/post_widgets.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({Key? key}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: bgApp,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                getPostSection(),
                const SizedBox(height: 10.0),
                getCommentSection(),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
        bottomNavigationBar: getCommentInputSection(),
      ),
    );
  }

  Container getCommentInputSection() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            icon: const CircleAvatar(
              child: ClipOval(
                child: Image(
                  height: 50.0,
                  width: 50.0,
                  image: AssetImage("assets/images/Kroni.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: -3),
            hintText: 'Add a comment',
            suffixIcon: IconButton(
              padding: const EdgeInsets.only(right: 10),
              onPressed: () {},
              icon: const Icon(
                Icons.send,
                size: 25.0,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container getPostSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                ),
              ),
              Expanded(
                child: PostHeadlineWidget(
                  username: "thieen_aan",
                  time: DateTime.now(),
                  postAvatar: "assets/images/Kroni.jpg",
                ),
              ),
            ],
          ),
          const PostImgWidget(postImage: "assets/images/WTF.jpg"),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "Why im i still here? \n just to suffer ?",
              softWrap: true,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            ),
          ),
          const PostIconWidget(
            likeCount: 170,
            commentCount: 190,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Container getCommentSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: <Widget>[
          getComment("Jokeroni", "What the ?", "assets/images/JOKERONI.jpg"),
          getComment("Veibae", "Nice !", "assets/images/Veibae.jpeg"),
          getComment("Gawr_Gura", "Oh My Gah!", "assets/images/Gumba.jpg"),
          getComment("Its_Chirstmas", "This is so cursed ~",
              "assets/images/padoru.jpg"),
          getComment("HandsomeGuy", "What the ?", "assets/images/Whut.jpg"),
        ],
      ),
    );
  }

  ListTile getComment(String username, String comment, String img) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(15, 10, 5, 10),
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
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(comment),
      trailing: Material(
        color: Colors.white,
        child: IconButton(
          splashRadius: 20,
          icon: const Icon(
            Icons.favorite_border,
          ),
          color: Colors.grey,
          iconSize: 27,
          onPressed: () {},
        ),
      ),
    );
  }
}
