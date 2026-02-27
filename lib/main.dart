import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TweetsScreen(),
    );
  }
}

class TweetsScreen extends ConsumerWidget {
  const TweetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tweets = ref.watch(tweetsProvider);
    return Scaffold(
      body: Center(child: Text(tweets.map((tweet) => tweet.text).join('\n'))),
    );
  }
}

final tweetsProvider = NotifierProvider<TweetsNotifier, List<Tweet>>(
  TweetsNotifier.new,
);

class TweetsNotifier extends Notifier<List<Tweet>> {
  @override
  List<Tweet> build() {
    return [
      Tweet(text: 'Hello, world1!'),
      Tweet(text: 'Hello, world2!'),
      Tweet(text: 'Hello, world3!'),
    ];
  }
}

class Tweet {
  final String text;

  Tweet({required this.text});
}
