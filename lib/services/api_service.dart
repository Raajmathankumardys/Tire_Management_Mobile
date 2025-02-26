import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
enum DioMethod { post, get, put, delete }

class APIService {

  APIService._singleton();

  static final APIService instance = APIService._singleton();

  String? get baseUrl {

    if (kDebugMode) {
      return dotenv.env["BASE_URL"];
    }
    return dotenv.env["BASE_URL"];
  }

  Future<Response> request(
      String endpoint,
      DioMethod method, {
        Map<String, dynamic>? param,
        String? contentType,
        formData,
      }) async {
    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: baseUrl as String,
          contentType: contentType ?? Headers.formUrlEncodedContentType,
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.acceptHeader: "application/json",
          },
        ),
      );
      switch (method) {
        case DioMethod.post:
          return dio.post(
            endpoint,
            data: param ?? formData,
          );
        case DioMethod.get:
          return dio.get(
            endpoint,
            queryParameters: param,
          );
        case DioMethod.put:
          return dio.put(
            endpoint,
            data: param ?? formData,
          );
        case DioMethod.delete:
          return dio.delete(
            endpoint,
            data: param ?? formData,
          );
        default:
          return dio.post(
            endpoint,
            data: param ?? formData,
          );
      }
    } catch (e) {
      print(e);
      throw Exception('Network error $e');
    }
  }
}