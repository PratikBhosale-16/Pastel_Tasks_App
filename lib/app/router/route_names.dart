/// Central route names and paths for the application shell.
abstract final class RouteNames {
  const RouteNames._();

  /// Bootstrap splash route name.
  static const splash = 'splash';

  /// Bootstrap splash route path.
  static const splashPath = '/splash';

  /// Home route name.
  static const home = 'home';

  /// Home route path.
  static const homePath = '/';

  /// Archive route name.
  static const archive = 'archive';

  /// Archive route path.
  static const archivePath = '/archive';

  /// Completed tasks route name.
  static const completedTasks = 'completed_tasks';

  /// Completed tasks route path.
  static const completedTasksPath = '/completed_tasks';

  /// Tags route name.
  static const tags = 'tags';

  /// Tags route path.
  static const tagsPath = '/tags';

  /// Calendar route name.
  static const calendar = 'calendar';

  /// Calendar route path.
  static const calendarPath = '/calendar';

  /// Settings route name.
  static const settings = 'settings';

  /// Settings route path.
  static const settingsPath = '/settings';

  /// Task details route name.
  static const taskDetails = 'taskDetails';

  /// Task details route path.
  static const taskDetailsPath = '/task/:id';
}
