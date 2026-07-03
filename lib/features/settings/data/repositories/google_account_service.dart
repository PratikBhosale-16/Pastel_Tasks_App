import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:pastel_tasks/features/settings/domain/models/profile_model.dart';
import 'package:pastel_tasks/features/settings/domain/repositories/account_service.dart';

class GoogleAccountService implements AccountService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveAppdataScope,
    ],
  );

  ProfileModel _currentProfile = ProfileModel.guest();

  @override
  ProfileModel get currentProfile => _currentProfile;

  @override
  Future<ProfileModel> initialize() async {
    final account = await _googleSignIn.signInSilently();
    _updateProfile(account);
    return _currentProfile;
  }

  @override
  Future<ProfileModel> signIn() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Google Sign-In failed or was cancelled.');
    }
    _updateProfile(account);
    return _currentProfile;
  }

  @override
  Future<ProfileModel> signOut() async {
    await _googleSignIn.signOut();
    _currentProfile = ProfileModel.guest();
    return _currentProfile;
  }

  @override
  Future<http.Client?> getAuthenticatedClient() async {
    if (_googleSignIn.currentUser == null) return null;
    return await _googleSignIn.authenticatedClient();
  }

  void _updateProfile(GoogleSignInAccount? account) {
    if (account == null) {
      _currentProfile = ProfileModel.guest();
    } else {
      _currentProfile = ProfileModel(
        id: account.id,
        name: account.displayName ?? 'Google User',
        email: account.email,
        photoUrl: account.photoUrl,
        isGuest: false,
      );
    }
  }
}
