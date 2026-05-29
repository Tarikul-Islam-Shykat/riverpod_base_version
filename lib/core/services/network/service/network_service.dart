import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_base/core/services/network/config/dio_config.dart';
import 'package:riverpod_base/core/services/network/error/failure.dart';

import '../error/error_handler.dart';

enum RequestMethod { get, post, put, delete, patch }

final networkServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return NetworkService(dio);
});

class NetworkService {
  final Dio _dio;

  NetworkService(this._dio);

  Future<Either<Failure, T>> request<T>(
    String url, {
    required RequestMethod method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isAuth = false,
  }) async {
    if (!await InternetConnectionChecker.instance.hasConnection) {
      return Left(NetworkFailure("Please connect to the internet"));
    }

    try {
      final response = await _dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method.name.toUpperCase(),
          extra: {'isAuth': isAuth},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data as T);
      } else {
        return Left(ErrorHandler.handle(response) as Failure);
      }
    } on DioException catch (e) {
      return Left(ErrorHandler.handle(e) as Failure);
    } catch (e) {
      return Left(ErrorHandler.handle(e) as Failure);
    }
  }

  Future<Either<Failure, T>> multipartRequest<T>(
    String url, {
    required RequestMethod method,
    Map<String, dynamic>? data,
    Map<String, File>? files,
    bool isAuth = false,
  }) async {
    if (!await InternetConnectionChecker.instance.hasConnection) {
      return Left(NetworkFailure("Please connect to the internet"));
    }

    try {
      final formData = FormData();

      if (data != null) {
        formData.fields.add(MapEntry('data', jsonEncode(data)));
      }

      if (files != null) {
        for (var entry in files.entries) {
          formData.files.add(MapEntry(
            entry.key,
            await MultipartFile.fromFile(
              entry.value.path,
              filename: entry.value.path.split('/').last,
            ),
          ));
        }
      }

      final response = await _dio.request(
        url,
        data: formData,
        options: Options(
          method: method.name.toUpperCase(),
          extra: {'isAuth': isAuth},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data as T);
      } else {
        return Left(ErrorHandler.handle(response) as Failure);
      }
    } on DioException catch (e) {
      return Left(ErrorHandler.handle(e) as Failure);
    } catch (e) {
      return Left(ErrorHandler.handle(e) as Failure);
    }
  }

  Future<Either<Failure, T>> get<T>(String url,
          {Map<String, dynamic>? queryParameters, bool isAuth = false}) =>
      request<T>(url,
          method: RequestMethod.get,
          queryParameters: queryParameters,
          isAuth: isAuth);

  Future<Either<Failure, T>> post<T>(String url,
          {dynamic data, bool isAuth = false}) =>
      request<T>(url, method: RequestMethod.post, data: data, isAuth: isAuth);

  Future<Either<Failure, T>> put<T>(String url,
          {dynamic data, bool isAuth = false}) =>
      request<T>(url, method: RequestMethod.put, data: data, isAuth: isAuth);

  Future<Either<Failure, T>> patch<T>(String url,
          {dynamic data, bool isAuth = false}) =>
      request<T>(url, method: RequestMethod.patch, data: data, isAuth: isAuth);

  Future<Either<Failure, T>> delete<T>(String url,
          {dynamic data, bool isAuth = false}) =>
      request<T>(url, method: RequestMethod.delete, data: data, isAuth: isAuth);
}
