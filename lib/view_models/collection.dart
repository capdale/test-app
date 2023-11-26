import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:modak/modak.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;

Future<Collections> getCollectionInfoFromStorage(Modak modak) async {
  final appDocDir = await getApplicationDocumentsDirectory();
  await updateCollectionInfo(modak);
  final file = io.File(p.join(appDocDir.absolute.path, "collection_info.json"));
  final fileAsString = await file.readAsString();
  return Collections.fromJson(jsonDecode(fileAsString));
}

Future<void> updateCollectionInfo(Modak modak) async {
  final collections = await modak.collection.getCollections();
  final appDocDir = await getApplicationDocumentsDirectory();
  final collectionInfoPath =
      p.join(appDocDir.absolute.path, "collection_info.json");

  final file = await io.File(collectionInfoPath).create();

  await file.writeAsString(jsonEncode(collections.toJson()));
}

Future<io.File> getCollectionImageFile(
    Collection collection, Modak modak) async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final isFileExist =
      await io.File(p.join(appDocDir.absolute.path, "${collection.uuid}.jpg"))
          .exists();
  final filepath = p.join(appDocDir.absolute.path, "${collection.uuid}.jpg");
  if (!isFileExist) {
    await downloadCollectionImageFromModak(collection, modak, filepath);
  }
  return io.File(filepath);
}

Future<void> downloadCollectionImageFromModak(
    Collection collection, Modak modak, String savePath) async {
  final response = await Dio().get(
      "https://collection.themodak.com/${collection.uuid}.jpg",
      options: Options(responseType: ResponseType.bytes));
  await io.File(savePath).writeAsBytes(response.data);
}
