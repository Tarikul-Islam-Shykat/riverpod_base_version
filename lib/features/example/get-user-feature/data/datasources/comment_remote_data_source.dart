import 'package:fpdart/fpdart.dart';

import '../../../../../core/constants/endpoinst.dart';
import '../../../../../core/services/network/error/failure.dart';
import '../../../../../core/services/network/service/network_service.dart';
import '../models/comment_model.dart';

class CommentRemoteDataSource {
  CommentRemoteDataSource(this._networkService);

  final NetworkService _networkService;

  Future<Either<Failure, List<CommentModel>>> getCommentsByPostId(
    int postId,
  ) async {
    final result = await _networkService.get<List<dynamic>>(
      AppEndpoints.jsonPlaceholderComments,
      queryParameters: {'postId': postId},
    );

    return result.map(
      (response) {
        return response
            .whereType<Map>()
            .map((item) =>
                CommentModel.fromJson(Map<String, dynamic>.from(item)))
            .toList(growable: false);
      },
    );
  }
}
