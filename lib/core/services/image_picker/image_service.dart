import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'error/failure.dart';

final imageServiceProvider = Provider((ref) => ImageService());

class ImageService {
  final ImagePicker _picker = ImagePicker();
  Future<Either<Failure, File>> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        return Right(File(pickedFile.path));
      }
      return Left(ImagePickFailure("No image selected"));
    } catch (e) {
      return Left(ImagePickFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<File>>> pickMultiImage({int? limit}) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        limit: limit,
      );
      if (pickedFiles.isNotEmpty) {
        return Right(pickedFiles.map((x) => File(x.path)).toList());
      }
      return Left(ImagePickFailure("No images selected"));
    } catch (e) {
      return Left(ImagePickFailure(e.toString()));
    }
  }

  Future<Either<Failure, File>> compressImage(
    File file, {
    int targetSizeKb = 30,
  }) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          "${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg";

      int quality = 80;
      XFile? result;

      while (quality >= 10) {
        result = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          targetPath,
          quality: quality,
          minWidth: 800,
          minHeight: 800,
          format: CompressFormat.jpeg,
        );

        if (result == null) break;

        final size = await File(result.path).length();
        if (size <= targetSizeKb * 1024) {
          break; // Success! Size is within target
        }

        quality -= 15; // Reduce quality for next pass
      }

      if (result != null) {
        return Right(File(result.path));
      }
      return Left(
        CompressionFailure("Failed to compress image to desired size"),
      );
    } catch (e) {
      return Left(CompressionFailure(e.toString()));
    }
  }

  Future<Either<Failure, File>> pickAndCompress({
    required ImageSource source,
    int targetSizeKb = 30,
  }) async {
    final pickResult = await pickImage(source: source);
    return pickResult.fold(
      (failure) => Left(failure),
      (file) => compressImage(file, targetSizeKb: targetSizeKb),
    );
  }
}
