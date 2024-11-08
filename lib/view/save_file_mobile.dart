import 'dart:io';
import 'dart:io' as io;

import 'package:external_path/external_path.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

///To save the pdf file in the device
Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  //Get the storage folder location using path_provider package.
  String? path;
  if (Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isLinux ||
      Platform.isWindows) {
   /* final Directory directory =
        await path_provider.getApplicationSupportDirectory();
    path = directory.path;*/

    if (Platform.isAndroid) {
      path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
    } else if (Platform.isIOS) {
      Directory documents = await getApplicationDocumentsDirectory();
      path = documents.path;
    }

    await io.Directory('$path/Marie')
        .create(recursive: true)
        .then((value) {
      print("StoreageCreated------------------------->${value.path}");
      // return value.path;
    });
  } else {
    path = await PathProviderPlatform.instance.getApplicationSupportPath();
  }
  final File file =
      File(Platform.isWindows ? '$path\\$fileName' : '$path/Marie/$fileName');
  await file.writeAsBytes(bytes/*, flush: true*/);
  if (Platform.isAndroid || Platform.isIOS) {
    print('$path/Marie/$fileName');
    Fluttertoast.showToast(msg: "File Stored in $path/$fileName");
    // await open_file.OpenFile.open('$path/$fileName');
    final result = await OpenFile.open('$path/Marie/$fileName');
    print("type=${result.type}  message=${result.message}");
  } else if (Platform.isWindows) {
    await Process.run('start', <String>['$path\\$fileName'], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.run('open', <String>['$path/$fileName'], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', <String>['$path/$fileName'],
        runInShell: true);
  }
}
