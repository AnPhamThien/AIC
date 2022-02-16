part of "profile_bloc.dart";

class ProfileState {
  final UserDetails? user;
  final List<Post>? galleryPostList;
  final bool isCurrentUser;
  final ProfileStatus status;
  bool isFollow;
  final int postListPage;
  final int galleryPostListPage;
  final bool hasReachedMax;
  final bool galleryPostHasReachedMax;
  final bool needLeadBack;

  ProfileState(
      {this.user,
      this.galleryPostList,
      required this.isCurrentUser,
      this.isFollow = false,
      this.status = const InitialStatus(),
      this.postListPage = 1,
      this.galleryPostListPage = 1,
      this.hasReachedMax = false,
      this.galleryPostHasReachedMax = false,
      required this.needLeadBack});

  ProfileState copyWith(
      {UserDetails? user,
      List<Post>? galleryPostList,
      bool? isCurrentUser,
      ProfileStatus? status,
      bool? isFollow,
      int? postListPage,
      int? galleryPostListPage,
      bool? hasReachedMax,
      bool? galleryPostHasReachedMax,
      bool? needLeadBack}) {
    return ProfileState(
        user: user ?? this.user,
        galleryPostList: galleryPostList ?? this.galleryPostList,
        isCurrentUser: this.isCurrentUser,
        status: status ?? this.status,
        isFollow: isFollow ?? this.isFollow,
        postListPage: postListPage ?? this.postListPage,
        galleryPostListPage: galleryPostListPage ?? this.galleryPostListPage,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        galleryPostHasReachedMax:
            galleryPostHasReachedMax ?? this.galleryPostHasReachedMax,
        needLeadBack: needLeadBack ?? this.needLeadBack);
  }
}

abstract class ProfileStatus {
  const ProfileStatus();
}

class InitialStatus extends ProfileStatus {
  const InitialStatus();
}

class FinishInitializing extends ProfileStatus {}

class ReachedMaxedStatus extends ProfileStatus {}

class ErrorStatus extends ProfileStatus {
  final Exception exception;
  ErrorStatus(this.exception);
}
