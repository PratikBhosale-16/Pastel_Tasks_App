import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final bool isGuest;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.isGuest = false,
  });

  factory ProfileModel.guest() {
    return const ProfileModel(
      id: 'guest',
      name: 'Guest User',
      email: 'Sign in to enable cloud backup and future sync.',
      isGuest: true,
    );
  }

  @override
  List<Object?> get props => [id, name, email, photoUrl, isGuest];
}
