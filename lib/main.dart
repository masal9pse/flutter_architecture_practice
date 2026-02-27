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
      home: const ArticleListView(),
    );
  }
}

// 一覧画面
class ArticleListView extends ConsumerWidget {
  const ArticleListView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ref.watch(articlesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Articles')),
      body: ListView(
        children: [
          for (final article in articles) TextButton(
            child: Text('$article'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetailView(id: article.id)));
            },
          ),
        ],
      ),
    );
  }
}

// 詳細画面
class ArticleDetailView extends ConsumerWidget {
  const ArticleDetailView({
    super.key,
    required this.id,
  });

  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final article = ref.watch(
      articlesProvider.select(
        (articles) => articles.firstWhere((article) => article.id == id),
      ),
    );
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          child: Text('$article'),
          onPressed: () {
            ref.read(articlesProvider.notifier).like(id);
          },
        ),
      ),
    );
  }
}


final articlesProvider = NotifierProvider<ArticlesNotifier, List<Article>>(
  ArticlesNotifier.new,
);

// SSOTを満たした、記事データソース
class ArticlesNotifier extends Notifier<List<Article>> {
  @override
  List<Article> build() {
    return [
      Article(id: '1'),
      Article(id: '2'),
      Article(id: '3'),
      Article(id: '4'),
      Article(id: '5'),
    ];
  }

  void like(String id) {
    final index = state.indexWhere((article) => article.id == id);
    final article = state[index];
    state = List.of(state)
      ..[index] = Article(
        id: article.id,
        isLiked: true,
      );
  }
}

class Article  {
  final String id;
  final bool isLiked;

  Article({required this.id, this.isLiked = false});
}