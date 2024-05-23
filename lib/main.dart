import 'dart:html' as html;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mingo/SplashPage.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // html.window.onBlur.listen((html.Event e) {
  //   print("Tab blurred");
  //   captureScreen();
  // });

  // html.window.onKeyPress.listen((event) {
  //   //
  // });

  // html.window.onFocus.listen((html.Event e) {
  //   print("Tab coding");
  //   captureScreen();
  // });

  // html.window.onResize.listen((html.Event e) {
  //   print("Tab resized");
  //   captureScreen();
  // });

  // html.window.onKeyPress.listen((event) {
  //   print('keycode $event pressed from initstate');
  // });

  // html.window.onPageHide.listen((html.Event e) {
  //   print("Tab Hide");
  //   captureScreen();
  // });

  // // Add a listener for the visibility change event (when the tab is switched).
  // html.document.onVisibilityChange.listen((html.Event e) {
  //   if (html.document.visibilityState == 'hidden') {
  //     print("Tab switched");
  //     captureScreen();
  //   }
  //   if (html.document.visibilityState == 'visible') {
  //     print("Tab Focussed");
  //   }
  // });

  runApp(const MyApp());
}

void captureScreen() {
  final html.HtmlDocument htmlDocument =
      html.window.document as html.HtmlDocument;
  final html.HtmlElement body = htmlDocument.body!;

  html.ImageElement img = html.ImageElement(
      src: 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg"/>');
  body.append(img);

  html.CanvasElement canvas = html.CanvasElement(
      width: html.window.innerWidth, height: html.window.innerHeight);
  html.CanvasRenderingContext2D context = canvas.context2D;

  // Create an ImageElement and draw it onto the canvas.
  html.ImageElement bodyImage = html.ImageElement(
      width: html.window.innerWidth, height: html.window.innerHeight);
  bodyImage.src = img.src;
  context.drawImage(bodyImage, 0, 0);

  final imgData = canvas.toDataUrl("image/png");

  img.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: const TextTheme(
          displayMedium: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic),
          titleSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: Colors.orange),
        ),
      ),
      home: const SplashPage1(),
    );
  }
}
