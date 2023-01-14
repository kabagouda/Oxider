import 'package:ansicolor/ansicolor.dart';
import 'package:path/path.dart';

import 'dart:io';
import 'create.dart';
import 'build.dart';
import 'serve.dart';
import 'run.dart';

void main(List<String> arguments) async {
  //  Arguments here will be passed from the command line .
  String currentDirectory = Directory.current.path;
  // If no arguments are passed, show the help message.
  // 1-

  if (arguments.isEmpty) {
    print(globalHelpMessage()); //to print help message in console .
    exit(0);
  }

  //2-

  // If the first argument is create, create a new project.
  else if (arguments[0] == 'create') {
    if (arguments[1].isEmpty) {
      print('Please provide the project name.');
      exit(0);
    } else {
      String projectName =
          arguments[1]; // get the project name from the command line.
      String projectPath = join(currentDirectory,
          projectName); // get the project path by joining the current directory and the project name.
      //  Execute the create function. It will create a new project.(create.dart)
      executeCreate(projectName, currentDirectory, projectPath);
    }
  }

  //3-

  // If the first argument is run, run the project.
  else if (arguments[0] == 'run') {
    try {
      executeRun();
    } on Exception catch (e) {
      AnsiPen pen = AnsiPen()..red();
      print(pen(e));
    }
  }

  //4-

  // If the first argument is serve, serve the project.
  else if (arguments[0] == 'serve') {
    executeServe();
  }

  //5-

  // If the first argument is build, build the project.
  else if (arguments[0] == 'build') {
    //  Execute the build function. It will build the project.(build.dart)
    if (arguments.length > 1 && arguments[1].isNotEmpty) {
      if (arguments[1] == '--release' || arguments[1] == '-r') {
        executeBuildForRelease();
      } else if (arguments[1] == '--debug' || arguments[1] == '-d') {
        executeBuildForDebug();
      } else {
        print('Invalid build argument');
        print(buildHelpMessage());
      }
    } else {
      print('Default building');
      executeBuildForRelease();
    }
  }

  //------------------------------Other unknown command
  else {
    print('Unknown command: ${arguments[0]}');
    print(globalHelpMessage()); //to print help message
  }
}
//Run your Oxider web application in development mode . It will run the web page in the browser.
// Serve
//-------------------------------------All messages functions here  :

String globalHelpMessage() => '''
A command-line utility for Oxider development.

Common commands:

  oxider create <output directory>
    Create a new Oxider project in the specified directory.

  oxider run [options]
    Run your Oxider web application in development mode . It will run the web page in the browser. 

Usage: oxider <command> [arguments]

Global options:
-h, --help                  Print this usage information.
    --version               Reports the version of this tool.

Available commands:

Oxider SDK
  doctor            Show information about the installed tooling.
  downgrade         Downgrade Oxider to the last active version for the current channel.
  upgrade           Upgrade your copy of Oxider.

Project
  analyze           Analyze the project's Dart code.
  build             Builds the web project in release mode (Default )..
  clean             Delete the build/ and .dart_tool/ directories.
  create            Create a new Oxider project.
  format            Idiomatically format Dart source code.
  pub               Commands for managing Oxider packages.
  run               Run your Oxider web application in development mode . It will run the web page in the browser.
  test              Run Oxider unit tests for the current project.


Run "oxider help <command>" for more information about a command.

''';

String createHelpMessage() => '''
''';

String buildHelpMessage() => '''
''';

String runHelpMessage() => '''
''';

String serveHelpMessage() => '''
''';

// build --release
//   Builds the web project in release mode.
// build --debug
//   Builds the web project in debug mode.
