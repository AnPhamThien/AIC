import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/controller/home/home_bloc.dart';
import 'package:imagecaptioning/src/model/category/category.dart';
import 'package:imagecaptioning/src/model/category/category_respone.dart';
import 'package:imagecaptioning/src/model/generic/generic.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/repositories/post/post_repository.dart';
import 'package:stream_transform/stream_transform.dart';
part 'post_event.dart';
part 'post_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(const PostState()) {
    on<LikePress>(_onLikePress);
    on<Reset>(_onReset);
    on<SavePost>(_onSavePost, transformer: throttleDroppable(throttleDuration));
    on<UnsavePost>(_onUnsavePost,
        transformer: throttleDroppable(throttleDuration));
    on<GetCategory>(_onGetCategory,
        transformer: throttleDroppable(throttleDuration));
    on<ReportPost>(_onReportPost,
        transformer: throttleDroppable(throttleDuration));
    on<AddPost>(_onAddPost, transformer: throttleDroppable(throttleDuration));
    on<GetIsSave>(_onGetIsSave,
        transformer: throttleDroppable(throttleDuration));
    on<UpdatePost>(_onUpdatePost, transformer: throttleDroppable(throttleDuration));
  }

  final PostRepository _postRepository = PostRepository();
  final HomeBloc homeBloc = HomeBloc();

  void _onGetIsSave(
    GetIsSave event,
    Emitter<PostState> emit,
  ) async {
    try {
      if (event.isSave == 0) {
        emit(state.copyWith(isSaved: false));
      } else if (event.isSave == 1) {
        emit(state.copyWith(isSaved: true));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void _onReportPost(
    ReportPost event,
    Emitter<PostState> emit,
  ) async {
    try {
      GetResponseMessage _respone = await _postRepository.addReport(
          event.postId, event.categoryId, event.description);
      if (_respone.statusCode == StatusCode.successStatus) {
        emit(state.copyWith(status: PostStatus.reported));
      } else {
        throw Exception(_respone.messageCode);
      }
    } catch (e) {
      emit(state.copyWith(status: PostStatus.fail, error: e.toString()));
      log(e.toString());
    }
  }

  void _onGetCategory(
    GetCategory event,
    Emitter<PostState> emit,
  ) async {
    try {
      CategoryRespone _respone = await _postRepository.getCategory();
      List<Category>? _categoryList = _respone.data;
      if (_respone.statusCode == StatusCode.successStatus &&
          _categoryList != null) {
        emit(state.copyWith(categoryList: _categoryList));
      } else {
        throw Exception(_respone.messageCode);
      }
    } catch (e) {
      emit(state.copyWith(status: PostStatus.fail, error: e.toString()));
      log(e.toString());
    }
  }

  void _onSavePost(
    SavePost event,
    Emitter<PostState> emit,
  ) async {
    try {
      GetResponseMessage _respone =
          await _postRepository.savePost(event.postId);
      if (_respone.statusCode == StatusCode.successStatus) {
        emit(state.copyWith(
          postId: event.postId,
          status: PostStatus.save,
          isSaved: true,
        ));
        
      } else {
        throw Exception(_respone.messageCode);
      }
    } catch (e) {
      emit(state.copyWith(status: PostStatus.fail, error: e.toString()));
      log(e.toString());
    }
  }

  void _onUnsavePost(
    UnsavePost event,
    Emitter<PostState> emit,
  ) async {
    try {
      GetResponseMessage _respone =
          await _postRepository.unsavePost(event.postId);
      if (_respone.statusCode == StatusCode.successStatus) {
        emit(state.copyWith(
          postId: event.postId,
          status: PostStatus.save,
          isSaved: false,
        ));
        
      } else {
        throw Exception(_respone.messageCode);
      }
    } catch (e) {
      emit(state.copyWith(status: PostStatus.fail, error: e.toString()));
      log(e.toString());
    }
  }

  void _onLikePress(
    LikePress event,
    Emitter<PostState> emit,
  ) async {
    try {
      if (event.isLike == 0) {
        GetResponseMessage _respone =
            await _postRepository.addAndDeleteLike(event.postId);
        if (_respone.statusCode == StatusCode.successStatus) {
          emit(state.copyWith(
              status: PostStatus.like, postId: event.postId, needUpdate: true));
        }
      } else {
        GetResponseMessage _respone =
            await _postRepository.addAndDeleteLike(event.postId);
        if (_respone.statusCode == StatusCode.successStatus) {
          emit(state.copyWith(
              status: PostStatus.unlike,
              postId: event.postId,
              needUpdate: true));
        }
      }
    } catch (e) {
      emit(state.copyWith(status: PostStatus.fail, error: e.toString()));
      log(e.toString());
    }
  }

  void _onUpdatePost(
      UpdatePost event, Emitter<PostState> emit) async {
    try {
      String postId = event.postId;
      String newCaption = event.newCaption;
      GetResponseMessage? _respone = await _postRepository.updatePost(postId: postId, newCaption: newCaption);
      if (_respone == null) {
        throw Exception();
      } 
      int status = _respone.statusCode ?? 0;

      if (status == StatusCode.successStatus) {
        emit(state.copyWith(
              status: PostStatus.updated,
              postId: postId,
              postCaption: newCaption));
      } else {
        throw Exception(_respone.messageCode);
      }
    } catch (_) {
      emit(state.copyWith(status: PostStatus.fail, error: _.toString()));
      log(_.toString() + "update");
    }
  }

  void _onReset(
    Reset event,
    Emitter<PostState> emit,
  ) async {
    emit(state.copyWith(
        status: PostStatus.init, postId: '', post: null, needUpdate: false, isSaved: null, postCaption: '', error: ''));
  }

  void _onAddPost(
    AddPost event,
    Emitter<PostState> emit,
  ) async {
    try {
      emit(state.copyWith(status: PostStatus.added, post: event.post));
    } catch (e) {
      log(e.toString());
    }
  }
}
