import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaderboard_api_example/data/api.dart';
import 'package:leaderboard_api_example/generated/grpc/skllzz/challenge/challenge.pb.dart';

import '../generated/grpc/skllzz/lk/challenges.pb.dart';

final monitorRankProvider = StreamProvider.autoDispose<LeaderboardRank>((ref) {
  final api = ref.watch(manageChallengesClient);

  return api.monitorRank((ChallengesScope()
    ..clubId = "lostah"
    ..itemId = "075791b2-dd8b-43c0-9fa3-dd2a9d13b701"));
});
