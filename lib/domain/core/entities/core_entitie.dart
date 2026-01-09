///
/// Core entity example
class CoreEntitie {

}

class AutoMLConfig {
  final String project;
  final String groupName;
  final FeatureSelectionConfig featureSelection;
  final HPTuneConfig hpTune;
  final ModelInferenceConfig inferenceCriteria;
  final String mlflowExperiment;
  final String grafanaTableName;
  final String dashboardName;
  final Map<String, String>? trigger;

  AutoMLConfig({
    required this.project,
    required this.groupName,
    required this.featureSelection,
    required this.hpTune,
    required this.inferenceCriteria,
    required this.mlflowExperiment,
    required this.grafanaTableName,
    required this.dashboardName,
    this.trigger,
  });

  factory AutoMLConfig.fromJson(Map<String, dynamic> json) {
    return AutoMLConfig(
      project: json['project'],
      groupName: json['group_name'],
      featureSelection: FeatureSelectionConfig.fromJson(json['feature_selection']),
      hpTune: HPTuneConfig.fromJson(json['hp_tune']),
      inferenceCriteria: ModelInferenceConfig.fromJson(json['inference_criteria']),
      mlflowExperiment: json['mlflow_experiment'],
      grafanaTableName: json['grafana_table_name'],
      dashboardName: json['dashboard_name'],
      trigger: json['trigger'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project': project,
      'group_name': groupName,
      'feature_selection': featureSelection.toJson(),
      'hp_tune': hpTune.toJson(),
      'inference_criteria': inferenceCriteria.toJson(),
      'mlflow_experiment': mlflowExperiment,
      'grafana_table_name': grafanaTableName,
      'dashboard_name': dashboardName,
      'trigger': trigger,
    };
  }
  AutoMLConfig copyWith({
    String? project,
    String? groupName,
    FeatureSelectionConfig? featureSelection,
    HPTuneConfig? hpTune,
    ModelInferenceConfig? inferenceCriteria,
    String? mlflowExperiment,
    String? grafanaTableName,
    String? dashboardName,
    Map<String, String>? trigger,
  }) {
    return AutoMLConfig(
      project: project ?? this.project,
      groupName: groupName ?? this.groupName,
      featureSelection: featureSelection ?? this.featureSelection,
      hpTune: hpTune ?? this.hpTune,
      inferenceCriteria: inferenceCriteria ?? this.inferenceCriteria,
      mlflowExperiment: mlflowExperiment ?? this.mlflowExperiment,
      grafanaTableName: grafanaTableName ?? this.grafanaTableName,
      dashboardName: dashboardName ?? this.dashboardName,
      trigger: trigger ?? this.trigger,
    );
  }
}

class FeatureSelectionConfig {
  final int topFeaturesToSelect;
  final int countCategory;
  final double cutoff1Category;
  final double cutoffNan;
  final double maxCorrValue;
  final Map<String, dynamic> metricEval;
  final double? cvDiffValue;  // Nullable
  final String encodingCat;
  final String encodingNum;
  final String defaultCat;
  final String defaultNum;
  final double depth;
  final List<String> featuresToIgnore;
  final Map<String, dynamic> params;
  final bool useTempData;

  FeatureSelectionConfig({
    required this.topFeaturesToSelect,
    required this.countCategory,
    required this.cutoff1Category,
    required this.cutoffNan,
    required this.maxCorrValue,
    required this.metricEval,
    this.cvDiffValue,  // Nullable
    required this.encodingCat,
    required this.encodingNum,
    required this.defaultCat,
    required this.defaultNum,
    required this.depth,
    required this.featuresToIgnore,
    required this.params,
    required this.useTempData,
  });

  factory FeatureSelectionConfig.fromJson(Map<String, dynamic> json) {
    return FeatureSelectionConfig(
      topFeaturesToSelect: json['top_features_to_select'] ?? 10,  // Default value
      countCategory: json['count_category'] ?? 100,
      cutoff1Category: (json['cutoff_1_category'] ?? 0.99).toDouble(),
      cutoffNan: (json['cutoff_nan'] ?? 0.7).toDouble(),
      maxCorrValue: (json['max_corr_value'] ?? 0.6).toDouble(),
      metricEval: json['metric_eval'] ?? {'metric_name': 0},
      cvDiffValue: json['cv_diff_value']?.toDouble(),  // Nullable
      encodingCat: json['encoding_cat'] ?? 'WoE_cat_to_num',
      encodingNum: json['encoding_num'] ?? 'WoE_num_to_num',
      defaultCat: json['default_cat'] ?? '_NAN_',
      defaultNum: json['default_num'] ?? '_MEDIAN_',
      depth: (json['depth'] ?? 0.01).toDouble(),
      featuresToIgnore: (json['features_to_ignore'] as List<dynamic>?)
          ?.cast<String>() 
          ?? [],  // Handle null
      params: json['params'] ?? {},
      useTempData: json['use_temp_data'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top_features_to_select': topFeaturesToSelect,
      'count_category': countCategory,
      'cutoff_1_category': cutoff1Category,
      'cutoff_nan': cutoffNan,
      'max_corr_value': maxCorrValue,
      'metric_eval': metricEval,
      'cv_diff_value': cvDiffValue,
      'encoding_cat': encodingCat,
      'encoding_num': encodingNum,
      'default_cat': defaultCat,
      'default_num': defaultNum,
      'depth': depth,
      'features_to_ignore': featuresToIgnore,
      'params': params,
      'use_temp_data': useTempData,
    };
  }

  FeatureSelectionConfig copyWith({
    int? topFeaturesToSelect,
    int? countCategory,
    double? cutoff1Category,
    double? cutoffNan,
    double? maxCorrValue,
    Map<String, dynamic>? metricEval,
    double? cvDiffValue,
    String? encodingCat,
    String? encodingNum,
    String? defaultCat,
    String? defaultNum,
    double? depth,
    List<String>? featuresToIgnore,
    Map<String, dynamic>? params,
    bool? useTempData,
  }) {
    return FeatureSelectionConfig(
      topFeaturesToSelect: topFeaturesToSelect ?? this.topFeaturesToSelect,
      countCategory: countCategory ?? this.countCategory,
      cutoff1Category: cutoff1Category ?? this.cutoff1Category,
      cutoffNan: cutoffNan ?? this.cutoffNan,
      maxCorrValue: maxCorrValue ?? this.maxCorrValue,
      metricEval: metricEval ?? this.metricEval,
      cvDiffValue: cvDiffValue ?? this.cvDiffValue,
      encodingCat: encodingCat ?? this.encodingCat,
      encodingNum: encodingNum ?? this.encodingNum,
      defaultCat: defaultCat ?? this.defaultCat,
      defaultNum: defaultNum ?? this.defaultNum,
      depth: depth ?? this.depth,
      featuresToIgnore: featuresToIgnore ?? this.featuresToIgnore,
      params: params ?? this.params,
      useTempData: useTempData ?? this.useTempData,
    );
  }

}

class HPTuneConfig {
  final String sampling;
  final int cvFoldsNum;
  final Map<String, dynamic>? parameters;  // Nullable
  final Map<String, String>? metricScore;  // Nullable

  HPTuneConfig({
    required this.sampling,
    required this.cvFoldsNum,
    this.parameters,  // Nullable
    this.metricScore,  // Nullable
  });

  factory HPTuneConfig.fromJson(Map<String, dynamic> json) {
    return HPTuneConfig(
      sampling: json['sampling'] ?? 'TPE',
      cvFoldsNum: json['cv_folds_num'] ?? 3,
      parameters: json['parameters'],  // Может быть null
      metricScore: json['metric_score'] != null
          ? Map<String, String>.from(json['metric_score'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sampling': sampling,
      'cv_folds_num': cvFoldsNum,
      'parameters': parameters,
      'metric_score': metricScore,
    };
  }

   HPTuneConfig copyWith({
    String? sampling,
    int? cvFoldsNum,
    Map<String, dynamic>? parameters,
    Map<String, String>? metricScore,
  }) {
    return HPTuneConfig(
      sampling: sampling ?? this.sampling,
      cvFoldsNum: cvFoldsNum ?? this.cvFoldsNum,
      parameters: parameters ?? this.parameters,
      metricScore: metricScore ?? this.metricScore,
    );
  }
}

class ModelInferenceConfig {
  final String prodModelsFolder;
  final Map<String, double> metricGrowthValue;
  final int calculateThreshold;
  final List<double> threshold;
  final String? prodPath;  // Nullable

  ModelInferenceConfig({
    required this.prodModelsFolder,
    required this.metricGrowthValue,
    required this.calculateThreshold,
    required this.threshold,
    this.prodPath,  // Nullable
  });

  factory ModelInferenceConfig.fromJson(Map<String, dynamic> json) {
    return ModelInferenceConfig(
      prodModelsFolder: json['prod_models_folder'] ?? '',
      metricGrowthValue: (json['metric_growth_value'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, (value as num).toDouble()))
          ?? {},  // Default empty map
      calculateThreshold: json['calculate_threshold'] ?? 0,
      threshold: (json['threshold'] as List<dynamic>?)
          ?.map((x) => (x as num).toDouble()).toList()
          ?? [0.8, 0.8],  // Default value
      prodPath: json['prod_path'],  // Может быть null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prod_models_folder': prodModelsFolder,
      'metric_growth_value': metricGrowthValue,
      'calculate_threshold': calculateThreshold,
      'threshold': threshold,
      'prod_path': prodPath,
    };
  }

 ModelInferenceConfig copyWith({
    String? prodModelsFolder,
    Map<String, double>? metricGrowthValue,
    int? calculateThreshold,
    List<double>? threshold,
    String? prodPath,
  }) {
    return ModelInferenceConfig(
      prodModelsFolder: prodModelsFolder ?? this.prodModelsFolder,
      metricGrowthValue: metricGrowthValue ?? this.metricGrowthValue,
      calculateThreshold: calculateThreshold ?? this.calculateThreshold,
      threshold: threshold ?? this.threshold,
      prodPath: prodPath ?? this.prodPath,
    );
  } 
}