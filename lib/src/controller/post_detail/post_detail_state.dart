part of 'post_detail_bloc.dart';

enum PostDetailStatus { initial, success, failure, maxcomment }

class PostDetailState extends Equatable {
  const PostDetailState();

  @override
  List<Object> get props => [];
}

class PostDetailInitial extends PostDetailState {}
