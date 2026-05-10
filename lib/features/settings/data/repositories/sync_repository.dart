// lib/features/settings/data/repositories/sync_repository.dart

import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/service_account_credentials.dart';

class SyncRepository {
  final _scopes = [drive.DriveApi.driveFileScope];

  Future<AutoRefreshingAuthClient> _getAuthClient() async {
    final credentials = ServiceAccountCredentials.fromJson(serviceAccountCredentials);
    return await clientViaServiceAccount(credentials, _scopes);
  }

  Future<void> backupDatabase(String userId) async {
    final client = await _getAuthClient();
    try {
      final driveApi = drive.DriveApi(client);

      // 1. Find the "Heshab_Backups" folder ID
      final folderList = await driveApi.files.list(
        q: "name = 'Heshab_Backups' and mimeType = 'application/vnd.google-apps.folder' and trashed = false",
        spaces: 'drive',
      );

      if (folderList.files == null || folderList.files!.isEmpty) {
        throw Exception('Backup folder "Heshab_Backups" not found. Please share the folder with the Service Account email.');
      }
      final folderId = folderList.files!.first.id!;

      // 2. Get the local DB file
      final appDir = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(appDir.path, 'heshab_book.sqlite'));
      if (!await dbFile.exists()) return;

      // 3. Prepare the file for upload (overwrite existing backup for this user)
      final fileName = 'backup_$userId.sqlite';
      
      // Check if file exists to update it, or create new
      final existingFiles = await driveApi.files.list(
        q: "name = '$fileName' and '$folderId' in parents and trashed = false",
      );

      final driveFile = drive.File();
      driveFile.name = fileName;
      driveFile.parents = [folderId];

      if (existingFiles.files != null && existingFiles.files!.isNotEmpty) {
        // Update existing
        final fileId = existingFiles.files!.first.id!;
        await driveApi.files.update(
          driveFile,
          fileId,
          uploadMedia: drive.Media(dbFile.openRead(), await dbFile.length()),
        );
      } else {
        // Create new
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
        throw Exception('No backup found for this User ID.');
      }

      final fileId = files.files!.first.id!;
      final drive.Media response = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final appDir = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(appDir.path, 'heshab_book.sqlite'));
      
      // Save downloaded stream to local file
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
