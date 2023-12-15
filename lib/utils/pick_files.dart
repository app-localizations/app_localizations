import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

Future<List<CommomFile>> pickFiles(BuildContext context) async {
  final result = await openFiles(
    acceptedTypeGroups: [
      const XTypeGroup(
        label: 'App Localization',
        extensions: ['arb'],
      ),
    ],
  );
  return result.map((e) => CommomFile(xFile: e)).toList(growable: false);
}

class CommomFile {
  const CommomFile({
    this.platformFile,
    this.xFile,
  });

  final PlatformFile? platformFile;
  final XFile? xFile;

  String get name => platformFile?.name ?? xFile?.name ?? '';

  String get path => platformFile?.path ?? xFile?.path ?? '';

  Future<Uint8List> get bytes async {
    if (platformFile != null) {
      if (platformFile!.bytes != null) {
        return platformFile!.bytes!;
      } else if (platformFile!.path != null) {
        return File(platformFile!.path!).readAsBytes();
      }
    } else if (xFile != null) {
      return await xFile!.readAsBytes();
    }
    return Uint8List(0);
  }
}
