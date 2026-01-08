import 'dart:math';

import 'package:aro_monitoring/domain/core/result/result.dart';
import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/api_request.dart';
import 'package:aro_monitoring/infrastructure/config_data.dart';
import 'package:aro_monitoring/infrastructure/do_data.dart';
import 'package:aro_monitoring/infrastructure/api_query_type/python_query.dart';
import 'package:aro_monitoring/presentation/core/widgets/drop_down_container.dart';
import 'package:aro_monitoring/presentation/data/widgets/dialog.dart';
import 'package:aro_monitoring/presentation/data/widgets/table_headers.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:aro_monitoring/domain/core/entities/core_entitie.dart';

///
class ConfigDataBody extends StatefulWidget {
  final ConfigData configData;
  
  const ConfigDataBody({
    Key? key,
    required this.configData,
  }) : super(key: key);
  
  @override
  State<ConfigDataBody> createState() => _ConfigDataBodyState();
}

class _ConfigDataBodyState extends State<ConfigDataBody> {
  AutoMLConfig? _config;
  bool _isLoading = false;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _loadConfig();
  }
  
  Future<void> _loadConfig() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    final result = await widget.configData.getAutoMLConfig();
    
    result.fold(
      onData: (config) {
        if (mounted) {
          setState(() {
            _config = config;
            _isLoading = false;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _error = error.message;
            _isLoading = false;
          });
        }
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text('Ошибка:', style: Theme.of(context).textTheme.titleMedium),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadConfig,
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }
    
    if (_config == null) {
      return const Center(child: Text('Нет данных конфигурации'));
    }
    
    return _buildConfigForm(_config!);
  }
  
  Widget _buildConfigForm(AutoMLConfig config) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Ваша форма здесь
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AutoML Configuration',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text('Project: ${config.project}'),
                  Text('Group: ${config.groupName}'),
                  // ... остальные поля
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
