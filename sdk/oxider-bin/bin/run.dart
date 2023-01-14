import 'dart:convert' show Utf8Decoder;
import 'dart:io' show Directory, File, Platform, Process, stdout;

import 'package:ansicolor/ansicolor.dart';
// import 'package:browser_launcher/browser_launcher.dart';
import 'package:path/path.dart';
import 'project_string/web_js_live.js.dart';

void executeRun() async {
  print('Running the project...');
  // Move web content to build folder.
  // print(' Copying web content to build folder...');
  // moveAllFilesAndFolderFromWebToBuild();
  // print('Serving the web generated file...');
  // var port = '7000';
  var port = '8080';
  var web = 'web:$port'; // web is changed to build
  var alreadyLaunched = false;
  AnsiPen redPen = AnsiPen()..red();
  AnsiPen yellowPen = AnsiPen()..red();
  AnsiPen greenPen = AnsiPen()..red();
  print(yellowPen('Preparing Oxider server [1/3] ...'));
  var processNpx = await Process.run(' npx', ['kill-port', '5467'],
      runInShell: true, workingDirectory: Directory.current.path);
  print(yellowPen('Preparing Oxider server [2/3] ...'));
  var processNpx2 = await Process.run(' npx', ['kill-port', '8181'],
      runInShell: true, workingDirectory: Directory.current.path);
  print(yellowPen('Preparing Oxider server [3/3] ...'));
  var processNpx3 = await Process.run(' npx', ['kill-port', '8080'],
      runInShell: true, workingDirectory: Directory.current.path);
  print(greenPen('Lauching ... 🚀'));
  var process = await Process.start(
      // 'dart',
      // [
      //   'run',
      //   'build_runner',
      //   'serve',
      //   // web,
      //   '--delete-conflicting-outputs',
      //   '--use-polling-watcher'
      // ],
      'dart',
      [
        'run',
        'jaspr',
        'serve',
      ],
      runInShell: true,
      workingDirectory: Directory.current.path);

  process.stdout.transform(Utf8Decoder()).listen((element) async {
    var newElement =
        element.toString().replaceAll('jaspr', 'Oxider').toString().trim();
    // var temp1 = newElement.trim().contains('[INFO] Succeeded after');
    var temp1 = newElement.toString().trim().contains('Serving at');
    var temp2 = newElement.toString().trim().contains('reloaded');
    var temp3 = newElement.toString().trim().contains('Starting Oxider');
    var temp4 = newElement.trim().contains('build_web_compilers:entrypoint');

    if (temp1 == true) {
      print(colorString(newElement.trim()));
      // Update the hot reloader notifier
      if (alreadyLaunched == false) {
        print(redPen('Your website is running on http://localhost:$port .'));
        // await Chrome.startWithDebugPort(['http://localhost:$port'],
        //     debugPort: 0);
        // print('Launched Chrome with a debug port');
        // Launched default browser in windows
        print('Launching the default browser...');
        // openBrowser('http://localhost:$port');
        openBrowser('http://localhost:8080');
        alreadyLaunched = true;
        // Hot reloader and notifier
        addWebJsHotReloader();
        File(join(Directory.current.path, 'web/.hotreload/notifier.js'))
          ..createSync(recursive: true)
          ..writeAsStringSync('//' + DateTime.now().toString());
      }
      updateHotNotifier();
      alreadyLaunched = true;
    } else if (temp2 == true) {
      updateHotNotifier();
      print(colorString(newElement.trim()));
      //Nothing just skipped
    } else if (temp3 == true) {
      //-------------I don't know yet. Actually i think it'sfor smth skip
      //Nothing just skipped
    }
    //else if (newElement.trim().isEmpty) {
    //   //-------------I don't know yet. Actually i think it'sfor smth skip
    //   //Nothing just skipped
    // }
    else {
      print(colorString(newElement.trim()));
    }
  });
} //end of executeRun()

String colorString(String element) {
  if (element.contains('[INFO]')) {
    AnsiPen pen = AnsiPen()..blue();
    element = element.replaceAll('[INFO]', '');
    return pen('[INFO]') + element;
  } else if (element.contains('[WARNING]')) {
    AnsiPen pen = AnsiPen()..yellow();
    element = element.replaceAll('[WARNING]', '');
    return pen('[WARNING]') + element;
  } else if (element.contains('[SEVERE]')) {
    AnsiPen pen = AnsiPen()..red();
    element = element.replaceAll('[SEVERE]', '');
    return pen('[SEVERE]') + element;
  } else if (element.contains('[DEBUG]')) {
    AnsiPen pen = AnsiPen()..cyan();
    element = element.replaceAll('[DEBUG]', '');
    return pen('[DEBUG]') + element;
  } else {
    return element;
  }
}

void addWebJsHotReloader() {
  String _string = getWebJsLiveJS();
  File(join(Directory.current.path, 'web/.hotreload/hotreloader.js'))
    ..createSync(recursive: true)
    ..writeAsStringSync(_string);
}
// void addBuildYaml() {
//   String _string = getBuildYaml();
//   File(join(Directory.current.path, 'build.yaml'))
//     ..createSync(recursive: true)
//     ..writeAsStringSync(_string);
// }

Future<void> updateHotNotifier() async {
  String notifierContent =
      File(join(Directory.current.path, 'web/.hotreload/notifier.js'))
          .readAsStringSync();
  var diff = DateTime.now()
      .difference(DateTime.tryParse(notifierContent.replaceAll('//', ''))!)
      .inMilliseconds;
  if (diff > 7000) {
    File(join(Directory.current.path, 'web/.hotreload/notifier.js'))
        .writeAsStringSync('//' + DateTime.now().toString());
  }
}

void moveAllFilesAndFolderFromWebToBuild() {
  Directory(join(Directory.current.path, 'web')).listSync().forEach((element) {
    if (element is File) {
      File(join(Directory.current.path, 'build', basename(element.path)))
        ..createSync(recursive: true)
        ..writeAsBytesSync(element.readAsBytesSync());
    } else if (element is Directory) {
      Directory(join(Directory.current.path, 'build', basename(element.path)))
          .createSync(recursive: true);
      element.listSync().forEach((element2) {
        if (element2 is File) {
          File(join(Directory.current.path, 'build', basename(element.path),
                  basename(element2.path)))
              .writeAsBytesSync(element2.readAsBytesSync());
        }
      });
    }
  });
}

// Open defaut browser with url on all platforms
Future<void> openBrowser(String url) async {
  if (Platform.isWindows) {
    await Process.run('explorer', [url], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.run('open', [url], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', [url], runInShell: true);
  }
}

// String runHelpMessage() => '''
// 'Usage: bouchra <command> [<args>]';
// 'Commands:');
// '  <project-name>';
// '  test';
// '  run';
// '  help';
//  ''';
