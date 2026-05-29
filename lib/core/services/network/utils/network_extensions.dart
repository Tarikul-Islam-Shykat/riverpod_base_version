import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_base/core/services/network/error/failure.dart';

import '../service/network_service.dart';

/// Shorthand extensions for WidgetRef (used in UI)
extension NetworkWidgetRefX on WidgetRef {
  NetworkService get net => read(networkServiceProvider);

  Future<Either<Failure, T>> get<T>(String url, {Map<String, dynamic>? queryParameters, bool isAuth = false}) =>
      net.get<T>(url, queryParameters: queryParameters, isAuth: isAuth);

  Future<Either<Failure, T>> post<T>(String url, {dynamic data, bool isAuth = false}) =>
      net.post<T>(url, data: data, isAuth: isAuth);

  Future<Either<Failure, T>> put<T>(String url, {dynamic data, bool isAuth = false}) =>
      net.put<T>(url, data: data, isAuth: isAuth);

  Future<Either<Failure, T>> patch<T>(String url, {dynamic data, bool isAuth = false}) =>
      net.patch<T>(url, data: data, isAuth: isAuth);

  Future<Either<Failure, T>> delete<T>(String url, {dynamic data, bool isAuth = false}) =>
      net.delete<T>(url, data: data, isAuth: isAuth);

  Future<Either<Failure, T>> multipart<T>(String url, {required RequestMethod method, Map<String, dynamic>? data, Map<String, File>? files, bool isAuth = false}) =>
      net.multipartRequest<T>(url, method: method, data: data, files: files, isAuth: isAuth);
}

/// Shorthand extensions for Ref (used in Providers)
extension NetworkRefX on Ref {
  NetworkService get net => read(networkServiceProvider);

  Future<Either<Failure, T>> get<T>(String url, {Map<String, dynamic>? queryParameters, bool isAuth = false}) =>
      net.get<T>(url, queryParameters: queryParameters, isAuth: isAuth);

  Future<Either<Failure, T>> post<T>(String url, {dynamic data, bool isAuth = false}) =>
      net.post<T>(url, data: data, isAuth: isAuth);

  Future<Either<Failure, T>> put<T>(String url, {dynamic data, bool isAuth = false}) =>
      net.put<T>(url, data: data, isAuth: isAuth);

  Future<Either<Failure, T>> patch<T>(String url, {dynamic data, bool isAuth = false}) =>
      net.patch<T>(url, data: data, isAuth: isAuth);

  Future<Either<Failure, T>> delete<T>(String url, {dynamic data, bool isAuth = false}) =>
      net.delete<T>(url, data: data, isAuth: isAuth);

  Future<Either<Failure, T>> multipart<T>(String url, {required RequestMethod method, Map<String, dynamic>? data, Map<String, File>? files, bool isAuth = false}) =>
      net.multipartRequest<T>(url, method: method, data: data, files: files, isAuth: isAuth);
}
