import 'package:flutter/material.dart';
import 'package:flutter_architecture_practice/article/article_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
