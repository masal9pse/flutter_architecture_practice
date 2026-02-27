import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ArticleListView(),
    );
  }
}

class ArticleListView extends ConsumerWidget {
  const ArticleListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ref.watch(articlesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Articles')),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return ListTile(
            title: Text('Article ${article.id}'),
            trailing: IconButton(
              icon: const Icon(Icons.favorite),
              color: article.isLiked ? Colors.red : null,
              onPressed: () {
                ref.read(articlesProvider.notifier).toggleLike(article.id);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailView(id: article.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Article ${article.id}'),
            const SizedBox(height: 16),
            IconButton(
              iconSize: 40,
              icon: const Icon(Icons.favorite),
              color: article.isLiked ? Colors.red : null,
              onPressed: () {
                ref.read(articlesProvider.notifier).toggleLike(id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

final articlesProvider = NotifierProvider<ArticlesNotifier, List<Article>>(
  ArticlesNotifier.new,
);

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

  void toggleLike(String id) {
    state = [
      for (final article in state)
        if (article.id == id)
          article.copyWith(isLiked: !article.isLiked)
        else
          article,
    ];
  }
}

class Article {
  final String id;
  final bool isLiked;

  Article({required this.id, this.isLiked = false});

  Article copyWith({String? id, bool? isLiked}) {
    return Article(
      id: id ?? this.id,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
