import 'dart:async';
import 'dart:convert';
import 'dart:io' show Directory, File, Process, exit, stdin, stdout;

import 'package:ansicolor/ansicolor.dart';
import 'package:path/path.dart';

import 'run.dart';

//-------------------------------------Release Mode

void executeBuildForRelease() async {
  AnsiPen pen = AnsiPen()..red(bold: true); //red color and bold in terminal
  print(' Building web files ...');
  bool success = await _buildJSForRelease();
  if (!success) {
    print(pen('Something went wrong while building web files.'));
    exit(0);
  }
}

// Compilation failed.
Future<bool> _buildJSForRelease() async {
  var process = await Process.run(
      'dart compile js', ['-O4', '-o', 'web/main.dart.js', 'lib/main.dart'],
      runInShell: true, workingDirectory: Directory.current.path);
  stdout.write('${process.stdout}'); //decomment
  //to removing library Warning
  // stdout.write(
  //     '${process.stdout.substring(process.stdout.indexOf("/main.dart'.") + 12)}');
  if (process.stdout.toString().toLowerCase().contains('compiled')) {
    return true;
  } else {
    return false;
  }
}

//-------------------------------------Debug Mode

void executeBuildForDebug() async {
  AnsiPen pen = AnsiPen()..red(bold: true);
  print(' Building web files ...');
  bool success = await _buildJSForDebug();
  var alreadyLaunched = false;
  String? port;
  String? localhost;

  if (!success) {
    print(pen('Something went wrong while building web files.'));
    exit(0);
  } else {
    print('Node processing');
    var processNode = await Process.start('http-server', [],
        runInShell: true,
        workingDirectory: join(Directory.current.path, 'web'));

    processNode.stdout.transform(Utf8Decoder()).listen((element) async {
      var temp1 = element.trim().toString().contains('127.0.0.1');
      var temp2 = element.trim().contains('Serving `web`');
      if (temp1 == true) {
        // print(colorString(element.trim()));// Message too long so hiding it
        // Update the hot reloader notifier
        if (alreadyLaunched == false) {
          // print('Your website is running on http://localhost:$port .');
          String newElement = element.trim().split('http://')[1].trim();
          localhost = newElement.replaceAll('192.168.1.66', 'http://localhost');
          port =
              (newElement.substring(newElement.length - 4, newElement.length));
          print('port : $port');

          // await Chrome.startWithDebugPort(['http://localhost:$port'],
          //     debugPort: 0);
          // print('Launched Chrome with a debug port');
          // Launched default browser in windows
          print('Launching the default browser...');
          // openBrowser('http://localhost:$port');
          print(pen('Your website is running on $localhost '));
          print(pen('Press "r" or "R" to make a hot reload✨🔥.'));
          print(
              'For more detailed help message , press "h" and to quit press "q" or "Q".\n');
          openBrowser(localhost.toString());
          alreadyLaunched = true;
          // Hot reloader and notifier
          addWebJsHotReloader();
          File(join(Directory.current.path, 'web/.hotreload/notifier.js'))
            ..createSync(recursive: true)
            ..writeAsStringSync('//' + DateTime.now().toString());
        }
        updateHotNotifier();
        alreadyLaunched = true;
        // subscription?.cancel();
        processNode.kill();
        //--------------------
        stdin
          ..echoMode = false
          ..lineMode = false;
        var alreadyPressed = false;
        stdin.listen((List<int> codes) async {
          String value = String.fromCharCodes(codes);
          if (value == 'r' || value == 'R') {
            if (alreadyPressed == false) {
              alreadyPressed = true;
              // print(value);
              print(' Hot reloading ...');
              var stopwatch = Stopwatch()..start();
              var success = await _buildJSForDebug();
              success
                  ? print(
                      'Reloaded  successfully in ${stopwatch.elapsedMilliseconds} ms . \n')
                  : print(
                      pen('Something went wrong while building web files.'));
              // stdout.write(pen('Press "r" or "R" to make a hot reload✨🔥'));
              stopwatch.stop(); // to stop the timer .
              await Future.delayed(Duration(milliseconds: 1300), () {
                alreadyPressed = false;
              });
            }
          } else if (value == 'q' || value == 'Q') {
            // print(value);
            // var quitingProcess =
            stdout.write('Quiting , wait ...');
            await Process.run('npx', ['kill-port', '$port'], runInShell: true)
                .then((value) => print('See you soon 👋'));
            try {
              exit(0);
            } catch (e) {
              // print(e);
              exit(0);
            } finally {
              exit(0);
            }
          } else if (value == 'h') {
            if (alreadyPressed == false) {
              alreadyPressed = true;
              stdout.write(pen(
                  'Press "r" or "R" to make a hot reload✨🔥 --- Or  "q" to quit : \n'));
              await Future.delayed(Duration(milliseconds: 1300), () {
                alreadyPressed = false;
              });
            }
          }
        });
      } else if (temp2 == true) {
        //-------------I don't know yet. Actually i think it'sfor smth skip
        //Nothing just skipped
      } else if (element.trim().isEmpty) {
        //-------------I don't know yet. Actually i think it'sfor smth skip
        //Nothing just skipped
      } else {
        // print(pen(element.trim()));
        //Skip for now
      }
    });
  }
}

Future<bool> _buildJSForDebug() async {
  var process = await Process.run(
      'dart compile js', ['-O2', '-o', 'web/main.dart.js', 'lib/main.dart'],
      runInShell: true, workingDirectory: Directory.current.path);
  stdout.write('${process.stdout}'); //decomment
  //to removing library Warning
  // stdout.write(
  //     '${process.stdout.substring(process.stdout.indexOf("/main.dart'.") + 12)}');
  if (process.stdout.toString().toLowerCase().contains('compiled')) {
    return true;
  } else {
    return false;
  }
}
