import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:aro_monitoring/domain/core/entities/core_entitie.dart';

class AutoMLConfigEditor extends StatefulWidget {
  final AutoMLConfig initialConfig;
  final Function(AutoMLConfig)? onSave;
  
  const AutoMLConfigEditor({
    super.key,
    required this.initialConfig,
    this.onSave,
  });
  
  @override
  _AutoMLConfigEditorState createState() => _AutoMLConfigEditorState();
}

class _AutoMLConfigEditorState extends State<AutoMLConfigEditor> {
  late AutoMLConfig _config;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  String? _saveError;
  
  @override
  void initState() {
    super.initState();
    _config = widget.initialConfig;
  }
  
  Future<void> _saveConfig() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isSaving = true;
      _saveError = null;
    });
    
    try {
      // Здесь будет POST запрос к FastAPI
      // final savedConfig = await _postConfigToAPI(_config);
      
      // Пока просто имитируем сохранение
      await Future.delayed(const Duration(seconds: 1));
      
      if (widget.onSave != null) {
        widget.onSave!(_config);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Конфигурация успешно сохранена!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context, _config);
    } catch (e) {
      setState(() {
        _saveError = e.toString();
      });
    } finally {
      setState(() => _isSaving = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать конфигурацию'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveConfig,
            tooltip: 'Сохранить',
          ),
        ],
      ),
      body: _buildEditorForm(),
    );
  }
  
  Widget _buildEditorForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Основная информация
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            
            // Feature Selection
            _buildFeatureSelectionSection(),
            const SizedBox(height: 24),
            
            // HP Tuning
            _buildHPTuningSection(),
            const SizedBox(height: 24),
            
            // Model Inference
            _buildInferenceSection(),
            const SizedBox(height: 24),
            
            // Ошибка сохранения
            if (_saveError != null)
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(child: Text(_saveError!)),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 32),
            
            // Кнопки сохранения
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveConfig,
                    icon: _isSaving 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isSaving ? 'Сохранение...' : 'Сохранить'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Основная информация',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            TextFormField(
              initialValue: _config.project,
              decoration: const InputDecoration(
                labelText: 'Проект *',
                border: OutlineInputBorder(),
                hintText: 'Введите название проекта',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите название проекта';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(project: value);
                });
              },
            ),
            
            const SizedBox(height: 12),
            
            TextFormField(
              initialValue: _config.groupName,
              decoration: const InputDecoration(
                labelText: 'Группа *',
                border: OutlineInputBorder(),
                hintText: 'Введите название группы',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите название группы';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(groupName: value);
                });
              },
            ),
            
            const SizedBox(height: 12),
            
            TextFormField(
              initialValue: _config.mlflowExperiment,
              decoration: const InputDecoration(
                labelText: 'MLflow Эксперимент *',
                border: OutlineInputBorder(),
                hintText: 'Название эксперимента в MLflow',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите название эксперимента';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(mlflowExperiment: value);
                });
              },
            ),
            
            const SizedBox(height: 12),
            
            TextFormField(
              initialValue: _config.grafanaTableName,
              decoration: const InputDecoration(
                labelText: 'Grafana Таблица *',
                border: OutlineInputBorder(),
                hintText: 'Название таблицы в Grafana',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите название таблицы';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(grafanaTableName: value);
                });
              },
            ),
            
            const SizedBox(height: 12),
            
            TextFormField(
              initialValue: _config.dashboardName,
              decoration: const InputDecoration(
                labelText: 'Дашборд *',
                border: OutlineInputBorder(),
                hintText: 'Название дашборда',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите название дашборда';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(dashboardName: value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureSelectionSection() {
    final fs = _config.featureSelection;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feature Selection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            // Числовые поля в сетке
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 4,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: [
                _buildNumberField(
                  label: 'Кол-во фичей',
                  value: fs.topFeaturesToSelect,
                  onChanged: (value) {
                    setState(() {
                      _config = _config.copyWith(
                        featureSelection: fs.copyWith(topFeaturesToSelect: value),
                      );
                    });
                  },
                ),
                _buildNumberField(
                  label: 'Кол-во категорий',
                  value: fs.countCategory,
                  onChanged: (value) {
                    setState(() {
                      _config = _config.copyWith(
                        featureSelection: fs.copyWith(countCategory: value),
                      );
                    });
                  },
                ),
                _buildDoubleField(
                  label: 'Cutoff 1 Cat',
                  value: fs.cutoff1Category,
                  onChanged: (value) {
                    setState(() {
                      _config = _config.copyWith(
                        featureSelection: fs.copyWith(cutoff1Category: value),
                      );
                    });
                  },
                ),
                _buildDoubleField(
                  label: 'Cutoff NaN',
                  value: fs.cutoffNan,
                  onChanged: (value) {
                    setState(() {
                      _config = _config.copyWith(
                        featureSelection: fs.copyWith(cutoffNan: value),
                      );
                    });
                  },
                ),
                _buildDoubleField(
                  label: 'Max Corr',
                  value: fs.maxCorrValue,
                  onChanged: (value) {
                    setState(() {
                      _config = _config.copyWith(
                        featureSelection: fs.copyWith(maxCorrValue: value),
                      );
                    });
                  },
                ),
                _buildDoubleField(
                  label: 'Depth',
                  value: fs.depth,
                  onChanged: (value) {
                    setState(() {
                      _config = _config.copyWith(
                        featureSelection: fs.copyWith(depth: value),
                      );
                    });
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Кодирование
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: fs.encodingCat,
                    decoration: const InputDecoration(
                      labelText: 'Энкодинг категорий',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _config = _config.copyWith(
                          featureSelection: fs.copyWith(encodingCat: value),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: fs.encodingNum,
                    decoration: const InputDecoration(
                      labelText: 'Энкодинг чисел',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _config = _config.copyWith(
                          featureSelection: fs.copyWith(encodingNum: value),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Значения по умолчанию
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: fs.defaultCat,
                    decoration: const InputDecoration(
                      labelText: 'Default категорий',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _config = _config.copyWith(
                          featureSelection: fs.copyWith(defaultCat: value),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: fs.defaultNum,
                    decoration: const InputDecoration(
                      labelText: 'Default чисел',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _config = _config.copyWith(
                          featureSelection: fs.copyWith(defaultNum: value),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // CV Diff Value (optional)
            TextFormField(
              initialValue: fs.cvDiffValue?.toString(),
              decoration: const InputDecoration(
                labelText: 'CV Diff Value (опционально)',
                border: OutlineInputBorder(),
                hintText: '0.05',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    featureSelection: fs.copyWith(
                      cvDiffValue: double.tryParse(value),
                    ),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Features to ignore
            TextFormField(
              initialValue: fs.featuresToIgnore.join(', '),
              decoration: const InputDecoration(
                labelText: 'Игнорируемые фичи',
                border: OutlineInputBorder(),
                hintText: 'feature1, feature2, feature3',
              ),
              onChanged: (value) {
                final features = value.split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                setState(() {
                  _config = _config.copyWith(
                    featureSelection: fs.copyWith(featuresToIgnore: features),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Use temp data switch
            SwitchListTile(
              title: const Text('Использовать временные данные'),
              value: fs.useTempData,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    featureSelection: fs.copyWith(useTempData: value),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHPTuningSection() {
    final hp = _config.hpTune;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hyperparameter Tuning',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            TextFormField(
              initialValue: hp.sampling,
              decoration: const InputDecoration(
                labelText: 'Сэмплинг метод',
                border: OutlineInputBorder(),
                hintText: 'TPE, Random, Grid',
              ),
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    hpTune: hp.copyWith(sampling: value),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              initialValue: hp.cvFoldsNum.toString(),
              decoration: const InputDecoration(
                labelText: 'CV Folds',
                border: OutlineInputBorder(),
                hintText: '3',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _config = _config.copyWith(
                      hpTune: hp.copyWith(
                        cvFoldsNum: int.tryParse(value) ?? 3,
                      ),
                    );
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInferenceSection() {
    final ic = _config.inferenceCriteria;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Model Inference',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            TextFormField(
              initialValue: ic.prodModelsFolder,
              decoration: const InputDecoration(
                labelText: 'Папка моделей *',
                border: OutlineInputBorder(),
                hintText: '/path/to/models',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, укажите путь к моделям';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    inferenceCriteria: ic.copyWith(prodModelsFolder: value),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              initialValue: ic.prodPath,
              decoration: const InputDecoration(
                labelText: 'Продакшен путь (опционально)',
                border: OutlineInputBorder(),
                hintText: '/path/to/production',
              ),
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    inferenceCriteria: ic.copyWith(prodPath: value.isEmpty ? null : value),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Calculate Threshold
            DropdownButtonFormField<int>(
              value: ic.calculateThreshold,
              decoration: const InputDecoration(
                labelText: 'Рассчитывать порог',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 0, child: Text('Нет')),
                DropdownMenuItem(value: 1, child: Text('Да')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _config = _config.copyWith(
                      inferenceCriteria: ic.copyWith(calculateThreshold: value),
                    );
                  });
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Threshold values
            const Text('Пороговые значения:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: ic.threshold[0],
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    label: ic.threshold[0].toStringAsFixed(2),
                    onChanged: (value) {
                      setState(() {
                        final newThreshold = List<double>.from(ic.threshold);
                        newThreshold[0] = value;
                        _config = _config.copyWith(
                          inferenceCriteria: ic.copyWith(threshold: newThreshold),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Slider(
                    value: ic.threshold[1],
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    label: ic.threshold[1].toStringAsFixed(2),
                    onChanged: (value) {
                      setState(() {
                        final newThreshold = List<double>.from(ic.threshold);
                        newThreshold[1] = value;
                        _config = _config.copyWith(
                          inferenceCriteria: ic.copyWith(threshold: newThreshold),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Threshold 1: ${ic.threshold[0].toStringAsFixed(2)}'),
                Text('Threshold 2: ${ic.threshold[1].toStringAsFixed(2)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNumberField({
    required String label,
    required int value,
    required Function(int) onChanged,
  }) {
    return TextFormField(
      initialValue: value.toString(),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: (text) {
        if (text.isNotEmpty) {
          onChanged(int.tryParse(text) ?? value);
        }
      },
    );
  }
  
  Widget _buildDoubleField({
    required String label,
    required double value,
    required Function(double) onChanged,
  }) {
    return TextFormField(
      initialValue: value.toString(),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: (text) {
        if (text.isNotEmpty) {
          onChanged(double.tryParse(text) ?? value);
        }
      },
    );
  }
}