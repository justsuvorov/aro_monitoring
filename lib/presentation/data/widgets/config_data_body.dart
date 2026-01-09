import 'dart:math';
import 'dart:convert';
import 'package:aro_monitoring/domain/core/result/result.dart';
import 'package:aro_monitoring/infrastructure/api_address.dart';
import 'package:aro_monitoring/infrastructure/api_request.dart';
import 'package:aro_monitoring/infrastructure/config_data.dart';
import 'package:aro_monitoring/infrastructure/do_data.dart';
import 'package:aro_monitoring/infrastructure/api_query_type/python_query.dart';
import 'package:aro_monitoring/presentation/core/widgets/drop_down_container.dart';
import 'package:aro_monitoring/presentation/data/widgets/dialog.dart';
import 'package:aro_monitoring/presentation/data/widgets/config_editors.dart';
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
    
    return _buildCompactConfigForm(_config!);
  }
  
Widget _buildCompactConfigForm(AutoMLConfig config) {
  final fs = config.featureSelection;
  final hp = config.hpTune;
  final ic = config.inferenceCriteria;
  
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AutoML Configuration',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        // Основная информация
        _buildSectionTitle('Основная информация'),
        _buildInfoRow('Проект', config.project),
        _buildInfoRow('Группа', config.groupName),
        _buildInfoRow('MLflow', config.mlflowExperiment),
        _buildInfoRow('Grafana', config.grafanaTableName),
        _buildInfoRow('Дашборд', config.dashboardName),
        
        const SizedBox(height: 16),
        
        // Feature Selection
        _buildSectionTitle('Feature Selection'),
        _buildTwoColumnRow('Кол-во фичей для модели', '${fs.topFeaturesToSelect}', 'Максемальное количество категорий', '${fs.countCategory}'),
        _buildTwoColumnRow('Cutoff 1 Cat', '${fs.cutoff1Category}', 'Cutoff NaN', '${fs.cutoffNan}'),
        _buildTwoColumnRow('Max Corr', '${fs.maxCorrValue}', 'Depth', '${fs.depth}'),
        _buildTwoColumnRow('Энкодинг  кат. фичей', fs.encodingCat, 'Энкодинг числ. фичей', fs.encodingNum),
        _buildTwoColumnRow('Default Cat', fs.defaultCat, 'Default Num', fs.defaultNum),
        
        if (fs.featuresToIgnore.isNotEmpty)
          _buildInfoRow('Игнорируемые', fs.featuresToIgnore.join(', ')),
        
        const SizedBox(height: 16),
        
        // HP Tuning
        _buildSectionTitle('HP Tuning'),
        _buildTwoColumnRow('Сэмплинг', hp.sampling, 'CV Folds', '${hp.cvFoldsNum}'),
        
        const SizedBox(height: 16),
        
        // Inference
        _buildSectionTitle('Model Inference'),
        _buildInfoRow('Папка моделей', ic.prodModelsFolder),
        _buildInfoRow('Thresholds', ic.threshold.map((t) => t.toStringAsFixed(2)).join(', ')),
        
        const SizedBox(height: 24),
        
        // Кнопки
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showJsonPreview(config),
                child: const Text('Показать JSON'),
              ),
            ),
             Expanded(
              child: ElevatedButton(
                onPressed: _openEditor,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Редактировать'),
              ),
                ),
              ]
            ),
      ]
    )
  );
}

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.blue,
      ),
    ),
  );
}

Widget _buildTwoColumnRow(String label1, String value1, String label2, String value2) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label1, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value1, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label2, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value2, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        Expanded(
          flex: 3,
          child: SelectableText(value.isEmpty ? '—' : value),
        ),
      ],
    ),
  );
}

Widget _buildInfoCard(String title, String value) {
  return Card(
    elevation: 1,
    color: Colors.grey[50],
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}
void _showJsonPreview(AutoMLConfig config) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('AutoML Config JSON'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: SelectableText(
            JsonEncoder.withIndent('  ').convert(config.toJson()),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Закрыть'),
        ),
      ],
    ),
  );
}

void _openEditor() async {
  final updatedConfig = await Navigator.push<AutoMLConfig?>(
    context,
    MaterialPageRoute(
      builder: (context) => AutoMLConfigEditor(
        initialConfig: _config!,
      ),
    ),
  );
  
  // 2. Проверяем, вернулись ли новые данные
  if (updatedConfig != null && mounted) {
    // 3. Обновляем состояние с новыми данными
    setState(() {
      _config = updatedConfig; // <- Обновляем _config
    });
  }
}

}