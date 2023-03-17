// ignore_for_file: unused_local_variable, library_prefixes, file_names, duplicate_ignore

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as Im;
import 'dart:math' as Math;
import 'package:path_provider/path_provider.dart';
import 'package:soe/utils/golbal/golbal.dart';

class CompressImage {
  Future<File> takePicture(File _imageFile) async {
    if (Golbal.connectivityResult == 0) {
      return _imageFile;
    }
    final tempDir = await getTemporaryDirectory();
    int rand = Math.Random().nextInt(10000);
    CompressObject compressObject =
        CompressObject(_imageFile, tempDir.path, rand);
    String filePath = await _compressImage(compressObject);
    File file = File(Golbal.congty!.fileurl);
    //pop loading
    return file;
  }

  Future<String> _compressImage(CompressObject object) async {
    return compute(decodeImage, object);
  }

  static String decodeImage(CompressObject object) {
    Im.Image? image = Im.decodeImage(object.imageFile.readAsBytesSync());
    Im.Image smallerImage = Im.copyResize(image!,
        width: 1024); // choose the size here, it will maintain aspect ratio
    var decodedImageFile = File(object.path + '/img_${object.rand}.jpg');
    decodedImageFile.writeAsBytesSync(Im.encodeJpg(smallerImage, quality: 85));
    return decodedImageFile.path;
  }
}

class CompressObject {
  File imageFile;
  String path;
  int rand;

  CompressObject(this.imageFile, this.path, this.rand);
}
