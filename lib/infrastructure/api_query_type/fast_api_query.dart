import 'dart:convert';

import 'package:aro_monitoring/infrastructure/api_query_type/api_query_type.dart';
import 'package:aro_monitoring/domain/core/entities/core_entitie.dart';
import 'package:aro_monitoring/infrastructure/api_reply.dart';
import 'package:uuid/uuid.dart';

import 'package:http/http.dart' as http;


abstract class ApiQueryType {
  bool valid();
  String buildJson();
  String get authToken;
  String get id;
}

class FastApiQuery implements ApiQueryType {
  final String _baseUrl;
  final String _authToken = 'None';
  late String _id;

  FastApiQuery({
    required String baseUrl,
  }) : _baseUrl = baseUrl;

  @override
  bool valid() {
    return true;
  }

  @override
  String buildJson() {
    _id = const Uuid().v1();
    final jsonString = json.encode({
      'auth_token': _authToken,
      'id': _id,
      'status': 'status'
    });
    return jsonString;
  }

  @override
  String get authToken => _authToken;

  @override
  String get id => _id;

  Future<AutoMLConfig> getAutoMLDefaultConfig() async {
     try {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/default_automl_config'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      
      // ДЕТАЛЬНАЯ ОТЛАДКА
      print('🔍 DEBUG - Checking problematic fields:');
      
      // Проверяем ВСЕ числовые поля
      final featureSelection = jsonData['feature_selection'] as Map? ?? {};
      print('📊 Feature Selection fields:');
      for (final key in featureSelection.keys) {
        final value = featureSelection[key];
        print('  $key: $value (type: ${value.runtimeType})');
      }
      
      // Проверяем hp_tune
      final hpTune = jsonData['hp_tune'] as Map? ?? {};
      print('📊 HP Tune fields:');
      for (final key in hpTune.keys) {
        final value = hpTune[key];
        print('  $key: $value (type: ${value.runtimeType})');
      }
      
      // Проверяем inference_criteria
      final inference = jsonData['inference_criteria'] as Map? ?? {};
      print('📊 Inference fields:');
      for (final key in inference.keys) {
        final value = inference[key];
        print('  $key: $value (type: ${value.runtimeType})');
      }
      
      return AutoMLConfig.fromJson(jsonData);
    } else {
      throw Exception('HTTP ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    print('❌ CRITICAL ERROR: $e');
    print('📝 Stack trace: $stackTrace');
    rethrow;
  }
    
    
    try {
      
      final response = await http.post(
        Uri.parse('$_baseUrl/api/default_automl_config'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return AutoMLConfig.fromJson(jsonData);
      } else {
        throw Exception('Failed to load default config: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
