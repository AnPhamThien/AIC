import 'package:flutter/material.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late OverlayEntry _popupDialog;
  List<String> imageUrls = [
    'assets/images/Gumba.jpg',
    'assets/images/JOKERONI.jpg',
    'assets/images/Kroni.jpg',
    'assets/images/Veibae.jpeg',
    'assets/images/Whut.jpg',
    'assets/images/WTF.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
    'assets/images/Gumba.jpg',
  ];

  @override
  Widget build(BuildContext context) {
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
  }

  Widget _createGridTileWidget(String imgPath) => Builder(
        builder: (context) => GestureDetector(
          onTap: () {},
          onLongPress: () {
            _popupDialog = _createPopupDialog(imgPath);
            Overlay.of(context)!.insert(_popupDialog);
          },
          onLongPressEnd: (details) => _popupDialog.remove(),
          child: Image(
            image: AssetImage(imgPath),
            fit: BoxFit.cover,
          ),
        ),
      );

  OverlayEntry _createPopupDialog(String imgPath) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(imgPath),
      ),
    );
  }

  Widget _createPhotoTitle(String username, imagePath) => Container(
        width: double.infinity,
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(imagePath),
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

  Widget _createPopupContent(String imgPath) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _createPhotoTitle("thien__ann", "assets/images/Kroni.jpg"),
              SizedBox(
                width: double.infinity,
                child: Image(
                  image: AssetImage(imgPath),
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
