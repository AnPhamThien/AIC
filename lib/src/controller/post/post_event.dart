part of 'post_bloc.dart';

class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LikePress extends PostEvent {
  final String postId;
  final int isLike;
  const LikePress(this.postId, this.isLike);
}

class Reset extends PostEvent {}

class SavePost extends PostEvent {
  final String postId;
  const SavePost(this.postId);
}

class UnsavePost extends PostEvent {
  final String postId;
  const UnsavePost(this.postId);
}

class GetCategory extends PostEvent {}

class ReportPost extends PostEvent {
  final String postId;
  final String categoryId;
  final String description;

  const ReportPost(this.postId, this.categoryId, this.description);
}

class GetIsSave extends PostEvent {
  final int isSave;
  const GetIsSave(this.isSave);
}

class AddPost extends PostEvent {
  final Post post;
  const AddPost(this.post);
}

class UpdatePost extends PostEvent {
  final String postId;
  final String newCaption;

  const UpdatePost(this.postId, this.newCaption);
}
