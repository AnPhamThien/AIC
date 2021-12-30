import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imagecaptioning/src/constanct/env.dart';
import 'package:imagecaptioning/src/controller/post_detail/post_detail_bloc.dart';
import 'package:imagecaptioning/src/model/post/comment.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/widgets/post_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/utils/func.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({Key? key}) : super(key: key);
  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Post post = Post();
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
    super.dispose();
  }

  void _onScroll() {
    if (isScrollEnd(_scrollController)) {
      context.read<PostDetailBloc>().add(PostDetailFetchMoreComment());
    }
  }

  Future<void> _refresh() {
    setState(() {
      context.read<PostDetailBloc>().add(PostDetailInitEvent(post));
    });
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: bgApp,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: BlocBuilder<PostDetailBloc, PostDetailState>(
                builder: (context, state) {
                  switch (state.status) {
                    case PostDetailStatus.success:
                      final Post _post = state.post!;
                      post = state.post!;
                      final int _commentCount = state.commentCount ?? 0;
                      final List<Comment>? _commentList = state.commentList;
                      return Column(
                        children: [
                          getPostSection(
                            _post,
                            _commentCount,
                          ),
                          const SizedBox(height: 10.0),
                          getCommentSection(_commentList),
                          const SizedBox(height: 10.0),
                        ],
                      );
                    case PostDetailStatus.maxcomment:
                      return Column(
                        children: [
                          getPostSection(
                            state.post!,
                            state.commentCount!,
                          ),
                          const SizedBox(height: 10.0),
                          getCommentSection(state.commentList),
                          const SizedBox(height: 10.0),
                        ],
                      );
                    case PostDetailStatus.failure:
                      return const Center(
                        child: Text('Some thing went wrong'),
                      );
                    default:
                      return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
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

  Container getPostSection(Post post, int commentCount) {
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
                  userId: post.userId!,
                  username: post.userName!,
                  time: post.dateCreate!,
                  postAvatar: post.avataUrl!,
                ),
              ),
            ],
          ),
          PostImgWidget(postImage: post.imageUrl!),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              post.userCaption ?? post.aiCaption!,
              softWrap: true,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            ),
          ),
          PostIconWidget(
            isLike: post.isLike,
            likeCount: post.likecount,
            commentCount: commentCount,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget getCommentSection(List<Comment>? commentList) {
    return commentList!.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext _, int index) {
                final Comment _comment = commentList[index];
                return getComment(_comment);
              },
              itemCount: commentList.length,
            ),
          )
        : const SizedBox.shrink();
  }

  ListTile getComment(Comment comment) {
    final _calculatedTime = timeCalculate(comment.dateCreate ?? DateTime.now());
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(15, 10, 5, 10),
      leading: SizedBox(
        width: 60.0,
        height: 60.0,
        child: CircleAvatar(
          child: ClipOval(
            //avatar
            child: Image(
              height: 60.0,
              width: 60.0,
              image: comment.avataUrl != ""
                  ? NetworkImage(avatarUrl + comment.avataUrl!)
                  : const AssetImage("assets/images/Kroni.jpg")
                      as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      //username, comment content
      title: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: comment.userName ?? '',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
            ),
            const TextSpan(text: "  "),
            TextSpan(text: comment.content ?? ''),
          ],
        ),
      ),
      //datecreate
      subtitle: Text(_calculatedTime),
      //like button
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
