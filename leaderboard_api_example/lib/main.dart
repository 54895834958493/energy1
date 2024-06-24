


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaderboard_api_example/generated/grpc/skllzz/challenge/challenge.pb.dart';
import 'package:leaderboard_api_example/generated/grpc/skllzz/common/stat.pb.dart';
import 'data/monitor_rank.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Энергетика',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
            titleTextStyle: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 30,
            ),
          ),
          useMaterial3: false,
        ),
        home: const MyHomePage(title: 'Соревнование "Энергетика"'),
      ),
    );
  }
}
class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final api = ref.watch(monitorRankProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0FFFF), Color.fromARGB(255, 15, 102, 216)],
          ),
        ),
        child: api.when(
          data: (rank) {
            return ListView.builder(
              itemCount: rank.members.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                final member = rank.members[index];
                return _buildRankItem(context, index, member, rank.members);
              },
            );
          },
          error: (e, s) {
            return Center(child: Text(e.toString()));
          },
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
  Widget _buildRankItem(BuildContext context, int index, Member member, List<Member> allMembers) {
    final rank = index + 1;
    final progress = member.earnedValue / allMembers.fold<double>(0, (max, member) => member.earnedValue > max ? member.earnedValue : max);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getRankColor(rank).withOpacity(0.5),
          ),
          child: Text(
            '$rank',
            style: TextStyle(
              color: _getRankColor(rank),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          member.nickName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: const Color(0xFFE0FFFF),
                valueColor: AlwaysStoppedAnimation<Color>(_getRankColor(rank)),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${member.earnedValue.toInt()}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Color.fromARGB(255, 175, 87, 54);
      default:
        return const Color.fromARGB(255, 16, 50, 246);
    }
  }
}