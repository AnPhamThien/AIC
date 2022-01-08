import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/constant/env.dart';

import 'package:imagecaptioning/src/controller/profile/profile_bloc.dart';
import 'package:imagecaptioning/src/model/post/post.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late OverlayEntry _popupDialog;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        List<Post> imageUrls = state.user?.posts ?? [];
        return Scaffold(
          body: GridView.count(
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
            crossAxisCount: 3,
            childAspectRatio: 1.0,

            ///map ảnh vào listview
            children: imageUrls.map(_createGridTileWidget).toList(),
          ),
        );
      },
    );
  }

  Widget _createGridTileWidget(Post post) => Builder(
        builder: (context) => GestureDetector(
          onTap: () {},
          onLongPress: () {
            _popupDialog = _createPopupDialog(post);
            Overlay.of(context)!.insert(_popupDialog);
          },
          onLongPressEnd: (details) => _popupDialog.remove(),
          child: Image(
            image: post.imageUrl != null
                ? NetworkImage(postImageUrl + post.imageUrl.toString())
                : const AssetImage("assets/images/Kroni.jpg") as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      );

  OverlayEntry _createPopupDialog(Post post) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(post),
      ),
    );
  }

  Widget _createPhotoTitle(String username, String imagePath) => Container(
        width: double.infinity,
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: imagePath.isNotEmpty
                ? NetworkImage(avatarUrl + imagePath.toString())
                : const AssetImage("assets/images/Kroni.jpg") as ImageProvider,
          ),
          title: Text(
            username,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
      );

  Widget _createActionBar() => Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
            Icon(
              Icons.chat_bubble_outline_outlined,
              color: Colors.black,
            ),
            Icon(
              Icons.send,
              color: Colors.black,
            ),
          ],
        ),
      );

  Widget _createPopupContent(Post post) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _createPhotoTitle(post.userName ?? '', post.avataUrl ?? ''),
              SizedBox(
                width: double.infinity,
                child: Image(
                  image: post.imageUrl != null
                      ? NetworkImage(postImageUrl + post.imageUrl.toString())
                      : const AssetImage("assets/images/Kroni.jpg")
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              _createActionBar(),
            ],
          ),
        ),
      );
}

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo));

    controller.addListener(() => setState(() {}));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacityAnimation.value),
      child: Center(
        child: FadeTransition(
          opacity: scaleAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
