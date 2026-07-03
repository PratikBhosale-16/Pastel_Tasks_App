import 'package:http/http.dart' as http;
import 'package:pastel_tasks/features/settings/domain/models/profile_model.dart';

abstract class AccountService {
  /// Initializes the service and returns the current profile.
  Future<ProfileModel> initialize();
  
  /// Gets the current profile synchronously.
  ProfileModel get currentProfile;

  /// Signs the user in (e.g. with Google).
  Future<ProfileModel> signIn();

  /// Signs the user out, reverting to guest mode.
  Future<ProfileModel> signOut();

  /// Gets an authenticated HTTP client for accessing cloud resources like Drive.
  Future<http.Client?> getAuthenticatedClient();
}
