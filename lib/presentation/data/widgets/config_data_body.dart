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


enum ConfigViewMode {
  autoML,
  allModels,
}

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
  AllModelsConfig? _allModelsConfig;
  bool _isLoading = false;
  String? _error;
  ConfigViewMode _currentMode = ConfigViewMode.autoML;
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
    final result2 = await widget.configData.getAllModelsConfig();
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
    result2.fold(
      onData: (config) {
        if (mounted) {
          setState(() {
            _allModelsConfig = config;
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
    
    return _buildCombinedViewWithToggle();//_buildCompactAllModelsConfigForm(_allModelsConfig!);
  }
  Widget _buildCombinedViewWithToggle() {
  // Определяем начальный режим на основе типа конфигурации
  
  
  return Column(
    children: [
      // Панель переключения
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border(
            bottom: BorderSide(color: const Color.fromARGB(255, 221, 174, 174)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Переключатель
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color.fromARGB(255, 231, 182, 182)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Кнопка AutoML
                      _buildToggleButton(
                        'AutoML',
                        ConfigViewMode.autoML,
                      ),
                      
                      // Кнопка All Models
                      _buildToggleButton(
                        'Models Config',
                        ConfigViewMode.allModels,
                      ),
                    ],
                  );
                },
              ),
            ),
            
         
          ],
        ),
      ),
      
      // Контент в зависимости от выбранного режима
      Expanded(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _currentMode == ConfigViewMode.autoML
              ? _buildCompactConfigForm(_config!)
              : _buildCompactAllModelsConfigForm(_allModelsConfig!),
        ),
      ),
    ],
  );
}

Widget _buildToggleButton(
    String label,
    ConfigViewMode mode,
  ) {
    final isActive = _currentMode == mode;
    final color = mode == ConfigViewMode.autoML ? Colors.blue : Colors.green;
    final icon = mode == ConfigViewMode.autoML 
        ? Icons.auto_awesome 
        : Icons.list_alt;
    
    return Container(
      decoration: BoxDecoration(
        color: isActive ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (_currentMode != mode) {
              setState(() {
                _currentMode = mode;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isActive ? Colors.white : Colors.grey[700],
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.white : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
              ],
            ),
      ],
    ),
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


Widget _buildCompactAllModelsConfigForm(AllModelsConfig config) {
  final dataConfig = config.dataConfig;
  final modelConfig = config.modelsConfigs;
  
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Models Configuration',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        // Основная информация
        _buildSectionTitle('Основная информация'),
        _buildInfoRow('Группа моделей', config.groupName),
        _buildInfoRow('Проект', config.project),
        _buildInfoRow('Версия', config.version),

        const SizedBox(height: 16),
  
        // Конфигурация данных
        if (dataConfig != null) ...[
          _buildSectionTitle('Конфигурация данных'),
          _buildInfoRow('Источник данных', dataConfig.source ?? '—'),
          _buildInfoRow('Имя таблицы', dataConfig.tableNameSource ?? ''),
          _buildInfoRow('Путь к локальному файлу', dataConfig.localNameSource ?? '—'),
        
          if (dataConfig.extraColumns != null && dataConfig.extraColumns!.isNotEmpty)
            _buildInfoRow('Дополнительные поля', dataConfig.extraColumns!.join(', ')),
          
          if (dataConfig.separation != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow('Разделение на тестовую и обучающую выборку', dataConfig.separation!.kind),
            if (dataConfig.separation!.randomState != null)
              _buildInfoRow('Random State', '${dataConfig.separation!.randomState}'),
            if (dataConfig.separation!.testTrainProportion != null)
              _buildInfoRow('Test/Train proportion', dataConfig.separation!.testTrainProportion!.toStringAsFixed(2)),
          ],
        ],
        
        const SizedBox(height: 16),
        
        // Сводка по моделям
        _buildSectionTitle('Конфигурация моделей'),
        const SizedBox(height: 16),
        
        // Кнопки
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showAllModelsJsonPreview(config),
                child: const Text('Показать JSON'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},//=> _openAllModelsEditor(config),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Редактировать'),
              ),
            ),
          ],
        ),
        
       
      ],
    ),
  );
}



void _showAllModelsJsonPreview(AllModelsConfig config) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('AllModels Config JSON'),
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

void _openAllModelsEditor(AutoMLConfig config) async {
  final updatedConfig = await Navigator.push<AllModelsConfig?>(
    context,
    MaterialPageRoute(
      builder: (context) => AutoMLConfigEditor(
        initialConfig: config,
      ),
    ),
  );
  
  if (updatedConfig != null && mounted) {
    setState(() {
      //_allModelsConfig = updatedConfig;
    });
  }
}


void _showModelsTable(AllModelsConfig config) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Список моделей',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Название')),
                  DataColumn(label: Text('Цель')),
                  DataColumn(label: Text('Фичи')),
                  DataColumn(label: Text('Тип')),
                ],
                rows: config.modelsConfigs.map((model) {
                  String modelType = 'Custom';
                  if (model.paramsCatboost != null) modelType = 'CatBoost';
                  if (model.paramsXgb != null) modelType = 'XGBoost';
                  if (model.paramsGlm != null) modelType = 'GLM';
                  
                  return DataRow(
                    cells: [
                      DataCell(Text(model.name)),
                      DataCell(Text(model.objective ?? '—')),
                      DataCell(Text('${model.features.length}')),
                      DataCell(Text(modelType)),
                    ],
                    onSelectChanged: (_) {
                      _showModelDetails(model);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void _showModelDetails(ModelConfig model) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Модель: ${model.name}'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow('Цель', model.objective ?? '—'),
              _buildInfoRow('Обертка', model.wrapper ?? '—'),
              _buildInfoRow('Целевая колонка', model.columnTarget ?? '—'),
              _buildInfoRow('Колонка экспозиции', model.columnExposure ?? '—'),
              _buildInfoRow('Количество фичей', '${model.features.length}'),
              _buildInfoRow('Относительные фичи', '${model.relativeFeatures.length}'),
              
              const SizedBox(height: 16),
              if (model.paramsCatboost != null) ...[
                const Text('Параметры CatBoost:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...model.paramsCatboost!.entries.take(5).map((e) => 
                  Text('  ${e.key}: ${e.value}')),
              ],
              
              if (model.catFeaturesCatboost != null) ...[
                const SizedBox(height: 8),
                Text('Категориальные фичи: ${model.catFeaturesCatboost!.join(', ')}'),
              ],
            ],
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



}