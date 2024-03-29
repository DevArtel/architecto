import 'package:base/model/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postsProvider = StateNotifierProvider<PostsController, AsyncValue<List<Post>?>>((ref) => PostsController());

class PostsController extends StateNotifier<AsyncValue<List<Post>?>> {
  PostsController() : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    state = const AsyncValue.data(null);
  }

  Future<void> retry() async {
    state = const AsyncValue.loading();
    await Future<void>.delayed(const Duration(seconds: 1));
    state = AsyncValue.data(_generatePosts(3));
  }


  void like(Post post) {
    final posts = state.value!;
    final updatedList = posts.map((e) {
      if (e.name == post.name) {
        return Post(name: post.name, liked: !post.liked);
      } else {
        return e;
      }
    });

    state = AsyncValue.data(updatedList.toList());
  }

  void onLoadMoreClicked() {
    final posts = state.value!;
    final newPosts = _generatePosts(3, (index) => _generatePost(index + posts.length));

    state = AsyncValue.data(posts + newPosts);
  }

  Future<void> onPostClicked(Post post) async {}
}

List<Post> _generatePosts(int count, [Post Function(int) generator = _generatePost]) =>
    List<Post>.generate(count, generator);

Post _generatePost(int index) => Post(name: 'Post $index', liked: index.isEven);
