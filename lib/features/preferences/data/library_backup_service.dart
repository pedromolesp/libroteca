import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:tomora/features/library/data/book_repository.dart';
import 'package:tomora/features/library/domain/model/book.dart';

enum BackupResult { ok, empty, cancelled, failed }

/// Exporta / importa la biblioteca a un archivo JSON.
///
/// El export antiguo pedía `Permission.storage` y escribía a
/// `/storage/emulated/0/Download` a pelo — roto en Android 11+ (scoped
/// storage). Aquí se usa el diálogo de guardado del sistema (SAF) vía
/// `file_picker`, que no necesita permisos.
class LibraryBackupService {
  LibraryBackupService(this._repository);

  final BookRepository _repository;

  Future<BackupResult> export() async {
    try {
      final books = await _repository.getAll();
      if (books.isEmpty) return BackupResult.empty;

      final payload = jsonEncode(books.map((b) => b.toExportMap()).toList());
      final bytes = Uint8List.fromList(utf8.encode(payload));
      final stamp = DateTime.now()
          .toIso8601String()
          .split('.')
          .first
          .replaceAll(':', '-');

      final path = await FilePicker.saveFile(
        dialogTitle: 'Guardar biblioteca',
        fileName: 'tomora-$stamp.json',
        bytes: bytes,
      );
      return path == null ? BackupResult.cancelled : BackupResult.ok;
    } catch (_) {
      return BackupResult.failed;
    }
  }

  Future<BackupResult> import() async {
    try {
      final picked = await FilePicker.pickFile();
      if (picked == null) return BackupResult.cancelled;

      final raw = await File(picked.path!).readAsString();
      final decoded = jsonDecode(raw);
      final list = decoded is List ? decoded : const [];
      if (list.isEmpty) return BackupResult.empty;

      final books = list
          .map((e) => Book.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
      await _repository.importAll(books);
      return BackupResult.ok;
    } catch (_) {
      return BackupResult.failed;
    }
  }
}
