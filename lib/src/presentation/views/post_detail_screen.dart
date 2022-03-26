import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/post/post_bloc.dart';
import 'package:imagecaptioning/src/controller/profile/profile_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controller/post_detail/post_detail_bloc.dart';
import '../../model/post/comment.dart';
import '../../model/post/post.dart';
import '../../utils/func.dart';
import '../theme/style.dart';
import '../widgets/post_widgets.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen(
      {Key? key, required this.post, required this.isInContest})
      : super(key: key);
  final Post post;
  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
  final bool isInContest;
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Post post = Post();
  final _scrollController = ScrollController();
  final _commentController = TextEditingController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    post = widget.post;
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

  void _onRefresh() async {
    context.read<PostDetailBloc>().add(PostDetailInitEvent(post));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: bgApp,
        body: SafeArea(
          child: SmartRefresher(
            scrollController: _scrollController,
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: MultiBlocListener(
                listeners: [
                  BlocListener<PostDetailBloc, PostDetailState>(
                    listenWhen: (previous, current) =>
                        previous.status != current.status,
                    listener: (context, state) {
                      if (state.status == PostDetailStatus.deleted) {
                        state.commentList.removeAt(state.deleted!);
                        context.read<PostDetailBloc>().add(CommentDeleted());
                      }
                    },
                  ),
                  BlocListener<PostBloc, PostState>(
                    listener: (context, state) {
                      if (state.status == PostStatus.like &&
                          state.needUpdate == true) {
                        post.isLike = 1;
                        post.likecount = post.likecount! + 1;
                        context.read<PostBloc>().add(Reset());
                      } else if (state.status == PostStatus.unlike &&
                          state.needUpdate == true) {
                        post.isLike = 0;
                        post.likecount = post.likecount! - 1;
                        context.read<PostBloc>().add(Reset());
                      }
                      if (state.status == PostStatus.save &&
                          state.isSaved == false) {
                        post.isSaved = 0;
                        context.read<PostBloc>().add(Reset());
                      }
                      if (state.status == PostStatus.save &&
                          state.isSaved == true) {
                        post.isSaved = 1;
                        context.read<PostBloc>().add(Reset());
                      }

                      if (state.status == PostStatus.updated) {
                        if (state.postCaption != null) {
context.read<PostDetailBloc>().add(UpdatePostDetail(state.postCaption!));
                        }
                      
                      context.read<PostBloc>().add(Reset());
                      log("check");
                  }
                    },
                  ),
                ],
                child: BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    log("check1");
                    return BlocBuilder<PostDetailBloc, PostDetailState>(
                      builder: (context, state) {
                        log("check2");
                        switch (state.status) {
                          case PostDetailStatus.success:
                            final Post _post = state.post!;
                            final int _commentCount = state.commentCount ?? 0;
                            final List<Comment> _commentList =
                                state.commentList;
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
                          case PostDetailStatus.failure:
                            return const Center(
                              child: Text('Some thing went wrong'),
                            );
                          default:
                            return const Center(
                                child: CircularProgressIndicator());
                        }
                      },
                    );
                  },
                ),
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
          autocorrect: false,
          controller: _commentController,
          textAlignVertical: TextAlignVertical.center,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            icon: const CircleAvatar(
              child: ClipOval(
                child: Image(
                  height: 50.0,
                  width: 50.0,
                  image: AssetImage("assets/images/avatar_placeholder.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: -3),
            hintText: 'Add a comment',
            suffixIcon: IconButton(
              padding: const EdgeInsets.only(right: 10),
              onPressed: () {
                if (containsChar(_commentController.text)) {
                  context
                      .read<PostDetailBloc>()
                      .add(PostDetailAddComment(_commentController.text));
                  _commentController.clear();
                  FocusScope.of(context).unfocus();
                }
              },
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
                  Navigator.pop(context, post);
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
                  postAvatar: post.avataUrl,
                  postId: post.postId!,
                  isSave: post.isSaved!,
                  route: widget.isInContest
                      ? AppRouter.contestScreen
                      : AppRouter.rootScreen,
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
            postId: post.postId!,
            isLike: post.isLike!,
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
                return getComment(_comment, index);
              },
              itemCount: commentList.length,
            ),
          )
        : const SizedBox.shrink();
  }

  ListTile getComment(Comment comment, int index) {
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
                  : const AssetImage("assets/images/avatar_placeholder.png")
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
        child: isUser(comment.userId!)
            ? IconButton(
                splashRadius: 20,
                icon: const Icon(
                  Icons.clear_rounded,
                ),
                color: Colors.grey,
                iconSize: 27,
                onPressed: () {
                  showDeleteDialog(comment.id!, index);
                },
              )
            : null,
      ),
    );
  }

  Future<void> showDeleteDialog(String commentId, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actionsAlignment: MainAxisAlignment.center,
        title: const Text('Delete',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 23,
                color: Colors.black87,
                letterSpacing: 1.25,
                fontWeight: FontWeight.w500)),
        content: const Text('This comment will be deleted',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
              letterSpacing: 1.25,
            )),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context.read<PostDetailBloc>().add(
                    PostDetailDeleteComment(commentId, index),
                  );
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
