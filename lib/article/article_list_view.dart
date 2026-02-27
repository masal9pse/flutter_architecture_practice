import 'package:flutter/material.dart';
import 'package:flutter_architecture_practice/article/article_detail_view.dart';
import 'package:flutter_architecture_practice/article/article_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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