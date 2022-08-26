# Liveness camera for detecting fraud or detecting real person selfie

[![pub package](https://img.shields.io/pub/v/liveness_cam.svg)](https://pub.dev/packages/liveness_cam)
[![pub package](https://img.shields.io/twitter/follow/kakzaki_id.svg?colorA=1da1f2&colorB=&label=Follow%20on%20Twitter)](https://twitter.com/kakzaki_id)

## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: | :-: | :---: | :-----: |
|   ✔️  |    ✔️  |   ️X    |  ️X   |  ️ X    |   ️X     |


## Android setup
No specific setup required

## IOS
No specific setup required

## EXAMPLE

    import 'dart:io';
    import 'package:flutter/material.dart';
    import 'package:liveness_cam/liveness_cam.dart';

    void main() {
        runApp(const MyApp());
    }

    class MyApp extends StatefulWidget {
        const MyApp({Key? key}) : super(key: key);
    
        @override
        State<MyApp> createState() => _MyAppState();
    }

    class _MyAppState extends State<MyApp> {
        final _livenessCam = LivenessCam();
    
        File? result;

        @override
        void initState() {
            super.initState();
        }

        @override
        Widget build(BuildContext context) {
         return MaterialApp(
          home: Scaffold(
           appBar: AppBar(
             title: const Text('Liveness Cam')
           ),
           body: Center(
             child: Column(
                children: [
                  result != null ? Image.file(result!) : Container(),
                  const SizedBox(height: 20,),
                  Builder(builder: (context) {
                     return ElevatedButton(
                       onPressed: () {
                         _livenessCam.start(context).then((value) {
                            if (value != null) {
                               setState(() {
                                 result = value;
                               });
                            }
                         });
                       },
                        child: const Text(
                          "Start",
                          style: TextStyle(fontSize: 19),
                        ));
                  })
                ],
              ),
            ),
          ),
        );
      }
    }


## FUND

If you like my content, please consider buying me a coffee. Thank you for your support!

<a href="https://www.buymeacoffee.com/QP1rCmf5L" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/Z8Z6656JW)

bagi yang dari Indonesia bisa lewat saweria berikut

https://saweria.co/kakzaki
