import 'package:pastel_tasks/app/constants/app_constants.dart';
import 'package:pastel_tasks/app/environment/app_environment.dart';
import 'package:pastel_tasks/core/config/app_config.dart';

/// PastelTasks application configuration.
const appConfig = AppConfig(
  applicationName: AppConstants.appName,
  environmentName: AppEnvironment.name,
);
