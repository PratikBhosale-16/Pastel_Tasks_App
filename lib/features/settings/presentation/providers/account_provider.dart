import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastel_tasks/features/settings/data/repositories/google_account_service.dart';
import 'package:pastel_tasks/features/settings/domain/models/profile_model.dart';
import 'package:pastel_tasks/features/settings/domain/repositories/account_service.dart';

final accountServiceProvider = Provider<AccountService>((ref) {
  return GoogleAccountService();
});

class AccountNotifier extends StateNotifier<AsyncValue<ProfileModel>> {
  final AccountService _accountService;

  AccountNotifier(this._accountService) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final profile = await _accountService.initialize();
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      // Fallback to guest on error
      state = AsyncValue.data(ProfileModel.guest());
    }
  }

  Future<void> signIn() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _accountService.signIn();
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      // Revert to guest on failure
      state = AsyncValue.data(ProfileModel.guest());
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _accountService.signOut();
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      state = AsyncValue.data(ProfileModel.guest());
    }
  }
}

final accountProvider = StateNotifierProvider<AccountNotifier, AsyncValue<ProfileModel>>((ref) {
  return AccountNotifier(ref.watch(accountServiceProvider));
});
