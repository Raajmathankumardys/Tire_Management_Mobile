import 'package:dio/dio.dart';
import '../../../helpers/DioClient.dart';
import '../../../helpers/exception.dart';
import '../cubit/report_state.dart';

class ReportService {
  static final ReportService _instance = ReportService._internal();

  late final Dio _dio;

  factory ReportService() {
    return _instance;
  }
  bool isRedirectingToLogin = false;
  ReportService._internal() {
    _dio = DioClient.createDio();
    // Let other errors propagate
  }

  Future<ReportModel> fetchReport({
    required String startDate,
    required String endDate,
    String? tripId,
    String? vehicleNumber,
    String? driverName,
  }) async {
    final queryParameters = {
      'startDate': startDate,
      'endDate': endDate,
      if (tripId != null) 'tripId': tripId,
      if (vehicleNumber != null) 'vehicleNumber': vehicleNumber,
      if (driverName != null) 'driverName': driverName,
    };
    try {
      final response = await _dio.get('/reports/trips/combined',
          queryParameters: queryParameters);
      return ReportModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
