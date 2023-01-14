String getWebIndexHtml() => '''
<!DOCTYPE html>

<html>
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="scaffolded-by" content="https://github.com/kabagouda/oxider" />
    <title>projectName</title>
    <!-- Website icon -->
    <link
      rel="shortcut icon"
      target="_blank"
      href="./icon.png"
      type="image/x-icon"
    />
    <!-- Live reload -->
    <script src="js/.hotreloader.js"></script>
    <!-- Live reload notifier -->
    <script src="js/.hotreloader_notifier.js"></script>
    <!-- Main code  -->
    <script defer src="main.dart.js"></script>
  </head>
  
  <body>
    <div id="output"></div>
  </body>
</html>

''';
