import '../../models/social_post_model.dart';

class SocialPostLocalDataSource {
  static const Duration _fakeLatency = Duration(milliseconds: 1100);

  Future<List<SocialPostModel>> getPosts() async {
    await Future.delayed(_fakeLatency);

    return const [
      SocialPostModel(
        id: '1',
        title: 'Morning Focus',
        body: 'A simple learning post with a clean image and some text.',
        imageUrl:
            'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=1200',
      ),
      SocialPostModel(
        id: '2',
        title: 'Riverpod Notes',
        body: 'The UI watches one provider and everything flows from there.',
        imageUrl:
            'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=1200',
      ),
      SocialPostModel(
        id: '3',
        title: 'Clean Architecture',
        body: 'Domain keeps meaning, data keeps details, UI stays simple.',
        imageUrl:
            'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=1200',
      ),
    ];
  }
}
