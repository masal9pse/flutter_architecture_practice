import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final index = state.indexWhere((article) => article.id == id);
    final article = state[index];
    state = List.of(state)..[index] = article.copyWith(isLiked: !article.isLiked);
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
