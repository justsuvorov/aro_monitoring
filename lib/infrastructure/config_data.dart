import 'package:aro_monitoring/domain/core/error/failure.dart';
import 'package:aro_monitoring/domain/core/result/result.dart';
import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/api_request.dart';
import 'package:aro_monitoring/infrastructure/api_query_type/fast_api_query.dart';
import 'package:logging/logging.dart';
import 'package:aro_monitoring/domain/core/entities/core_entitie.dart';
import 'package:logging/logging.dart';

class ConfigData {
  final _log = Logger('ConfigData');
  final FastApiQuery _fastAPIQuery;
  
  ConfigData({
    required FastApiQuery fastAPIQuery,
  }) : _fastAPIQuery = fastAPIQuery;
  
  Future<Result<AutoMLConfig>> getAutoMLConfig() async {
    try {
      _log.fine('Fetching AutoML config from API...');
      
      if (!_fastAPIQuery.valid()) {
        return Result<AutoMLConfig>(
          error: Failure(
            message: 'API query validation failed',
            stackTrace: StackTrace.current,
          ),
        );
      }
      
      final config = await _fastAPIQuery.getAutoMLDefaultConfig();
      _log.fine('Config received: ${config.project}');
      
      return Result<AutoMLConfig>(data: config);
      
    } catch (e, stackTrace) {
      _log.severe('Error fetching AutoML config: $e', e, stackTrace);
      return Result<AutoMLConfig>(
        error: Failure(
          message: 'Error fetching config: $e',
          stackTrace: stackTrace,
        ),
      );
    }
  }
  
  // Метод all() который возвращает List<Map>
  Future<Result<List<Map<String, dynamic>>>> all() async {
    try {
      if (!_fastAPIQuery.valid()) {
        return Result<List<Map<String, dynamic>>>(
          error: Failure(
            message: 'SQL query is empty',
            stackTrace: StackTrace.current,
          ),
        );
      }
      
      final result = await _fastAPIQuery.getAutoMLDefaultConfig();
      
      // Преобразуем AutoMLConfig в List<Map> для совместимости
      final configMap = result.toJson();
      final listData = [configMap];
      
      return Result<List<Map<String, dynamic>>>(data: listData);
      
    } catch (e, stackTrace) {
      _log.severe('Error in ConfigData.all(): $e', e, stackTrace);
      return Result<List<Map<String, dynamic>>>(
        error: Failure(
          message: '[ConfigData.all] error: $e',
          stackTrace: stackTrace,
        ),
      );
    }
  }
}