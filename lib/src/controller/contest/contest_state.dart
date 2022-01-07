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
    this.contestPrizes = const <dynamic>[],
    this.totalParticipaters = 0,
    this.hasReachMax = false,
  });

  final ContestStatus status;
  final Contest? contest;
  final List<Post> post;
  final List<Post> topThreePost;
  final List<dynamic> contestPrizes;
  final int totalParticipaters;
  final bool hasReachMax;

  ContestState copyWith({
    ContestStatus? status,
    Contest? contest,
    List<Post>? post,
    List<Post>? topThreePost,
    List<dynamic>? contestPrizes,
    int? totalParticipaters,
    bool? hasReachMax,
  }) {
    return ContestState(
      status: status ?? this.status,
      contest: contest ?? this.contest,
      post: post ?? this.post,
      topThreePost: topThreePost ?? this.topThreePost,
      contestPrizes: contestPrizes ?? this.contestPrizes,
      totalParticipaters: totalParticipaters ?? this.totalParticipaters,
      hasReachMax: hasReachMax ?? this.hasReachMax,
    );
  }

  @override
  List<Object> get props => [
        status,
        post,
        topThreePost,
        contestPrizes,
        totalParticipaters,
        hasReachMax
      ];
}
