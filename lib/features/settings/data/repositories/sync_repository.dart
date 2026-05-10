// lib/features/settings/data/repositories/sync_repository.dart

import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class SyncRepository {
  // Define scopes for Google Drive access
  static const _scopes = [
    drive.DriveApi.driveFileScope,
  ];

  // Store the email manually since v7.2.0 removed currentUser getter
  String? _currentUserEmail;

  /// Getter for current signed in user email
  String? get currentUserEmail => _currentUserEmail;

  /// Public getter to trigger sign in and get Drive API
  Future<drive.DriveApi?> getDriveApi() => _getDriveApi();

  /// Helper to get an authenticated Drive API client
  Future<drive.DriveApi?> _getDriveApi() async {
    try {
      final signIn = GoogleSignIn.instance;

      // 1. Initialize the singleton
      await signIn.initialize();

      // 2. Trigger Authentication (Sign In)
      final GoogleSignInAccount account = await signIn.authenticate(
        scopeHint: _scopes,
      );

      // 3. Store the email for the UI
      _currentUserEmail = account.email;

      // 4. Request Authorization for Drive scopes
      final authResult = await account.authorizationClient.authorizeScopes(_scopes);

      // 5. Use the authClient extension method
      final httpClient = authResult.authClient(scopes: _scopes);

      return drive.DriveApi(httpClient);
    } catch (e) {
      return null;
    }
  }

  /// Helper to find or create the central backup folder
  Future<String> _getOrCreateFolder(drive.DriveApi driveApi) async {
    const folderName = 'Heshab_Backups';
    
    final folderList = await driveApi.files.list(
      q: "name = '$folderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false",
      spaces: 'drive',
    );

    if (folderList.files != null && folderList.files!.isNotEmpty) {
      return folderList.files!.first.id!;
    }

    final folderMetadata = drive.File()
      ..name = folderName
      ..mimeType = 'application/vnd.google-apps.folder';
    
    final newFolder = await driveApi.files.create(folderMetadata);
    return newFolder.id!;
  }

  Future<void> backupDatabase(String userId) async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) throw Exception('Google Sign-In failed. Please check your internet and try again.');

    try {
      final folderId = await _getOrCreateFolder(driveApi);
      final appDir = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(appDir.path, 'heshab_book.sqlite'));
      if (!await dbFile.exists()) throw Exception('Local database file not found.');

      final fileName = 'backup_$userId.sqlite';
      final existingFiles = await driveApi.files.list(
        q: "name = '$fileName' and '$folderId' in parents and trashed = false",
      );

      final driveFile = drive.File()
        ..name = fileName
        ..parents = [folderId];

      if (existingFiles.files != null && existingFiles.files!.isNotEmpty) {
        final fileId = existingFiles.files!.first.id!;
        await driveApi.files.update(
          driveFile,
          fileId,
          uploadMedia: drive.Media(dbFile.openRead(), await dbFile.length()),
        );
      } else {
        await driveApi.files.create(
          driveFile,
          uploadMedia: drive.Media(dbFile.openRead(), await dbFile.length()),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> restoreDatabase(String userId) async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) throw Exception('Google Sign-In failed. Please check your internet and try again.');

    try {
      final fileName = 'backup_$userId.sqlite';
      final files = await driveApi.files.list(
        q: "name = '$fileName' and trashed = false",
      );

      if (files.files == null || files.files!.isEmpty) {
        throw Exception('No cloud backup found for this account.');
      }

      final fileId = files.files!.first.id!;
      final drive.Media response = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final appDir = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(appDir.path, 'heshab_book.sqlite'));
      
      final List<int> dataBytes = [];
      await for (final chunk in response.stream) {
        dataBytes.addAll(chunk);
      }
      await dbFile.writeAsBytes(dataBytes);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    _currentUserEmail = null;
  }
}
