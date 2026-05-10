// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsRepositoryHash() =>
    r'6c418c60b6aa8daa8b2fa18ba3a36559cead0b60';

/// See also [settingsRepository].
@ProviderFor(settingsRepository)
final settingsRepositoryProvider =
    AutoDisposeProvider<SettingsRepository>.internal(
      settingsRepository,
      name: r'settingsRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$settingsRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsRepositoryRef = AutoDisposeProviderRef<SettingsRepository>;
String _$appThemeModeHash() => r'c2bbca81760119db1670adca49acee3317ebde59';

/// See also [AppThemeMode].
@ProviderFor(AppThemeMode)
final appThemeModeProvider =
    AutoDisposeNotifierProvider<AppThemeMode, String>.internal(
      AppThemeMode.new,
      name: r'appThemeModeProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appThemeModeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppThemeMode = AutoDisposeNotifier<String>;
String _$appLanguageHash() => r'4b218b805ea4606a315fb86b4ff10367d8dd0628';

/// See also [AppLanguage].
@ProviderFor(AppLanguage)
final appLanguageProvider =
    AutoDisposeNotifierProvider<AppLanguage, String>.internal(
      AppLanguage.new,
      name: r'appLanguageProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appLanguageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppLanguage = AutoDisposeNotifier<String>;
String _$biometricAuthHash() => r'cfb7a89892b001f600618736c1c4598531853424';

/// See also [BiometricAuth].
@ProviderFor(BiometricAuth)
final biometricAuthProvider =
    AutoDisposeNotifierProvider<BiometricAuth, bool>.internal(
      BiometricAuth.new,
      name: r'biometricAuthProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$biometricAuthHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BiometricAuth = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
