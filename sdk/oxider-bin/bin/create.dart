import 'dart:io' show Directory, File, Process, exit;
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:path/path.dart';
import 'project_string/project_string.dart';

Future<void> executeCreate(
    String projectName, String currentDirectory, String projectPath) async {
  //1- Verify if directory exist
  if (await Directory(join(currentDirectory, projectName)).exists()) {
    print("Directory '${join(currentDirectory, projectName)}' already exists");
  }
  //2- Create directory
  else {
    print('Creating project $projectName... ');
    var stopwatch1 = Stopwatch()..start(); // listen to the time
    //    1-------Creating of bin
    addBinServer(projectPath, projectName);
    //   2-------Creating of lib
    addLibMain(projectPath, projectName);
    //   3-------Creating of test
    addTestServer(projectPath, projectName);
    //   3-------Creating of web
    addWebIndexHtml(projectPath, projectName); // add index.html
    await addIcon(projectPath); // add icon
    addWebMain(projectPath, projectName); // add main.dart
    // await addWebCssOxiderCSS(projectPath, projectName); // add OxiderCSS.css
    // await addWebJsOxiderJS(projectPath, projectName); // add OxiderJS.js
    // addWebJsHotReloader(projectPath, projectName); // add liveJS.js

    //   4-------Creating of others stuff
    addDotDockerignore(projectPath, projectName); // add .dockerignore
    addDotGitignore(projectPath, projectName); // add .gitignore
    addAnalysisOptionsYaml(
        projectPath, projectName); // add analysis_options.yaml
    addBuildYaml(projectPath, projectName); // add build.yaml
    addCHANGELOGMd(projectPath, projectName); // add CHANGELOG.md
    addDockerfile(projectPath, projectName); // add Dockerfile
    addREADMEMd(projectPath, projectName); // add readme.md
    addPubspecYaml(projectPath, projectName); // add pubspec.yaml

    print('''
  bin/server.dart
  lib/main.dart
  test/server_test.dart
  web/index.html
  web/main.dart
  web/css/oxider-css.css
  web/js/oxider-js.js
  .dockerignore
  .gitignore
  analysis_options.yaml
  CHANGELOG.md
  Dockerfile
  README.md
  pubspec.yaml
    ''');
// --------------Pub get
    print('Running pub get...');
    final stopwatch2 = Stopwatch()..start();
    dartPubGet(projectName);
    // -------Succesfully message
    print(
        'Running "dart pub get" in app...                                ${stopwatch2.elapsedMilliseconds} ms');
    print(successfulMessage(
        projectName, projectPath, stopwatch1.elapsedMilliseconds));
    stopwatch1.stop();
    // quit the program
    try {
      exit(0);
    } catch (e) {
      // print(e);
      exit(0);
    } finally {
      exit(0);
    }
  }
}

void dartPubGet(String projectName) {
  var process = Process.runSync('dart', ['pub', 'get'],
      runInShell: true,
      workingDirectory: join(Directory.current.path, projectName));
  if (process.stderr.toString().contains('exit code: 128')) {
    dartPubGet(
        projectName); // repeat it because some time `dart pub get` provide error 128 for no reason .
  } else if (process.stdout
          .toString()
          .contains('Could not resolve URL "https://pub.dartlang.org"') ||
      process.stdout.toString().contains('exit code 69')) {
    print(process.stdout);
    try {
      exit(0);
    } catch (e) {
      // print(e);
      exit(0);
    } finally {
      exit(0);
    }
  } else if (process.stderr.toString().contains('exit code 1') ||
      process.stdout.toString().contains('exit code 1')) {
    print('Pub get failed');
    try {
      exit(0);
    } catch (e) {
      // print(e);
      exit(0);
    } finally {
      exit(0);
    }
  }
}

void addBinServer(String projectPath, String projectName) {
  String _string = getBinServer();
  _string = _string.replaceAll('projectName', projectName);
  File(join(projectPath, 'bin/server.dart'))
    ..createSync(recursive: true)
    ..writeAsStringSync(_string);
}

void addLibMain(String projectPath, String projectName) {
  String _string = getLibMain();
  _string = _string.replaceAll('projectName', projectName);
  File(join(projectPath, 'lib/main.dart'))
    ..createSync(recursive: true)
    ..writeAsStringSync(_string);
}

void addTestServer(String projectPath, String projectName) {
  String _string = getTestServer();
  _string = _string.replaceAll('projectName', projectName);
  File(join(projectPath, 'test/server_test.dart'))
    ..createSync(recursive: true)
    ..writeAsStringSync(_string);
}

void addWebIndexHtml(String projectPath, String projectName) {
  String _string = getWebIndexHtml();
  _string = _string.replaceAll('projectName', projectName);
  File(join(projectPath, 'web/index.html'))
    ..createSync(recursive: true)
    ..writeAsStringSync(_string);
}

Future<void> addIcon(String projectPath) async {
  try {
    String oxiderLogoUrl =
        'https://user-images.githubusercontent.com/64534846/159020857-25d6cdd5-d18a-4672-a430-024a7eea5a55.png';
    final http.Response responseData = await http.get(Uri.parse(oxiderLogoUrl));
    var uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    File(join(projectPath, 'web/icon.png'))
      ..createSync(recursive: true)
      ..writeAsBytesSync(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  } on Exception catch (e) {
    print('Unable to add oxider-css.css');
    print(e);
  }
}

void addWebMain(String projectPath, String projectName) {
  String _string = getWebMain();
  _string = _string.replaceAll('projectName', projectName);
  File(join(projectPath, 'web/main.dart'))
    ..createSync(recursive: true)
    ..writeAsStringSync(_string);
}

Future<void> addWebCssOxiderCSS(String projectPath, String projectName) async {
  try {
    String oxidercssUrl =
        'https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css';
    final http.Response responseData = await http.get(Uri.parse(oxidercssUrl));
    var _string = responseData.body;
    File(join(projectPath, 'web/css/oxider-css.css'))
      ..createSync(recursive: true)
      ..writeAsStringSync(_string);
  } on Exception catch (e) {
    print('Unable to add oxider-css.css');
    print(e);
  }
}

Future<void> addWebJsOxiderJS(String projectPath, String projectName) async {
  try {
    String oxiderjsUrl =
        'https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js';
    final http.Response responseData = await http.get(Uri.parse(oxiderjsUrl));
    var _string = responseData.body;
    File(join(projectPath, 'web/js/oxider-js.js'))
      ..createSync(recursive: true)
      ..writeAsStringSync(_string);
  } on Exception catch (e) {
    print('Unable to add oxider-js.js');
    print(e);
  }
}

// void addWebJsHotReloader(String projectPath, String projectName) {
//   String _string = getWebJsLiveJS();
//   _string = _string.replaceAll('projectName', projectName);
//   File(join(projectPath, 'web/js/.hotreloader.js'))
//     ..createSync(recursive: true)
//     ..writeAsStringSync(_string);
// }

void addDotDockerignore(String projectPath, String projectName) {
  String _string = getDotDockerignore();
  _string = _string.replaceAll('projectName', projectName);
  File(join(projectPath, '.dockerignore'))
    ..createSync(recursive: true)
    ..writeAsStringSync(_string);
}

void addDotGitignore(String projectPath, String projectName) {
  String _string = getDotGitignore();
  _string = _string.replaceAll('projectName', projectName);
  File(join(projectPath, '.gitignore'))
    ..createSync(recursive: true)
    ..writeAsStringSync(_string);
}

void addAnalysisOptionsYaml(String projectPath, String projectName) {
  String _string = getAnalysisOptionsYaml();
  _string = _string.replaceAll('projectName', projectName);
  File(join(projectPath, 'analysis_options.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync(_string);
}

void addBuildYaml(projectPath, projectName) {
  String _string = getBuildYaml();
  File(join(projectPath, 'build.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync(_string);
}

void addCHANGELOGMd(String projectPath, String projectName) {
  String _string = getCHANGELOGMd();
  _string = _string.replaceAll('projectName', projectName);
  File(join(projectPath, 'CHANGELOG.md'))
    ..createSync(recursive: true)
    ..writeAsStringSync(_string);
}

void addDockerfile(String projectPath, String projectName) {
  String _string = getDockerfile();
  _string = _string.replaceAll('projectName', projectName);
  File(join(projectPath, 'Dockerfile'))
    ..createSync(recursive: true)
    ..writeAsStringSync(_string);
}

void addPubspecYaml(String projectPath, String projectName) {
  String _string = getPubspecYaml();
  _string = _string.replaceAll('projectName', projectName);
  File(join(projectPath, 'pubspec.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync(_string);
}

void addREADMEMd(String projectPath, String projectName) {
  String _string = getREADMEMd();
  _string = _string.replaceAll('projectName', projectName);
  File(join(projectPath, 'README.md'))
    ..createSync(recursive: true)
    ..writeAsStringSync(_string);
}

//--------------------------------- Message ---------------------------------
String successfulMessage(
        String projectName, String projectPath, int stopWatch) =>
    '''All done!                         
In order to run your project, type:
  \$ cd $projectName
  \$ oxider run
''';
// Your web application code is in ${join(projectName, 'lib', 'main.dart')} and server code is in ${join(projectName, 'bin', 'server.dart')}
