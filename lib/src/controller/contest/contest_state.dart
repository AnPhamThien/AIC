part of 'contest_bloc.dart';

enum ContestStatus {
  initial,
  success,
  failure,
  maxpost,
}

class ContestState extends Equatable {
  const ContestState({
    this.status = ContestStatus.initial,
    this.contest,
    this.post = const <Post>[],
    this.topThreePost = const <Post>[],
    this.totalParticipaters = 0,
    this.hasReachMax = false,
    this.prizes = const <Prize>[],
  });

  final ContestStatus status;
  final Contest? contest;
  final List<Post> post;
  final List<Post> topThreePost;
  final int totalParticipaters;
  final bool hasReachMax;
  final List<Prize> prizes;

  ContestState copyWith({
    ContestStatus? status,
    Contest? contest,
    List<Post>? post,
    List<Post>? topThreePost,
    int? totalParticipaters,
    bool? hasReachMax,
    List<Prize>? prizes,
  }) {
    return ContestState(
      status: status ?? this.status,
      contest: contest ?? this.contest,
      post: post ?? this.post,
      topThreePost: topThreePost ?? this.topThreePost,
      totalParticipaters: totalParticipaters ?? this.totalParticipaters,
      hasReachMax: hasReachMax ?? this.hasReachMax,
      prizes: prizes ?? this.prizes,
    );
  }

  @override
  List<Object> get props => [
        status,
        post,
        topThreePost,
        totalParticipaters,
        hasReachMax,
        prizes,
      ];
}
