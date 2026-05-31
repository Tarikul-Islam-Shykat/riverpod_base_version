import 'package:fpdart/fpdart.dart';

import '../../../../../core/constants/endpoinst.dart';
import '../../../../../core/services/network/error/failure.dart';
import '../../../../../core/services/network/service/network_service.dart';
import '../models/post_model.dart';

class PostsRemoteDataSource {
  PostsRemoteDataSource(this._networkService);

  final NetworkService _networkService;

  Future<Either<Failure, List<PostModel>>> getPosts() async {
    final result = await _networkService.get<List<dynamic>>(
      AppEndpoints.jsonPlaceholderPosts,
    );

    return result.map(
      (response) => response
          .whereType<Map>()
          .map((json) => PostModel.fromJson(Map<String, dynamic>.from(json)))
          .toList(growable: false),
    );
  }
}
