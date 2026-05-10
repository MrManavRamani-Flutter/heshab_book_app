// lib/features/settings/data/repositories/sync_repository.dart

import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/service_account_credentials.dart';

class SyncRepository {
  // Upgraded to driveScope for full access to shared folders
  final _scopes = [drive.DriveApi.driveScope];

  Future<AutoRefreshingAuthClient> _getAuthClient() async {
    final credentials = ServiceAccountCredentials.fromJson(serviceAccountCredentials);
    return await clientViaServiceAccount(credentials, _scopes);
  }

  /// Helper to find or create the central backup folder
  Future<String> _getOrCreateFolder(drive.DriveApi driveApi) async {
    const folderName = 'Heshab_Backups';
    
    // Search for existing folder
    final folderList = await driveApi.files.list(
      q: "name = '$folderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false",
      spaces: 'drive',
    );

    if (folderList.files != null && folderList.files!.isNotEmpty) {
      return folderList.files!.first.id!;
    }

    // Not found? Create it automatically
    final folderMetadata = drive.File()
      ..name = folderName
      ..mimeType = 'application/vnd.google-apps.folder';
    
    final newFolder = await driveApi.files.create(folderMetadata);
    return newFolder.id!;
  }

  Future<void> backupDatabase(String userId) async {
    final client = await _getAuthClient();
    try {
      final driveApi = drive.DriveApi(client);

      // 1. Ensure the vault exists
      final folderId = await _getOrCreateFolder(driveApi);

      // 2. Get the local DB file
      final appDir = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(appDir.path, 'heshab_book.sqlite'));
      if (!await dbFile.exists()) throw Exception('Local database not found.');

      // 3. Prepare the file for upload
      final fileName = 'backup_$userId.sqlite';
      
      final existingFiles = await driveApi.files.list(
        q: "name = '$fileName' and '$folderId' in parents and trashed = false",
      );

      final driveFile = drive.File()
        ..name = fileName
        ..parents = [folderId];

      if (existingFiles.files != null && existingFiles.files!.isNotEmpty) {
        // Update existing backup
        final fileId = existingFiles.files!.first.id!;
        await driveApi.files.update(
          driveFile,
          fileId,
          uploadMedia: drive.Media(dbFile.openRead(), await dbFile.length()),
        );
      } else {
        // Create new backup entry
        await driveApi.files.create(
          driveFile,
          uploadMedia: drive.Media(dbFile.openRead(), await dbFile.length()),
        );
      }
    } finally {
      client.close();
    }
  }

  Future<void> restoreDatabase(String userId) async {
    final client = await _getAuthClient();
    try {
      final driveApi = drive.DriveApi(client);

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
      
    } finally {
      client.close();
    }
  }
}
