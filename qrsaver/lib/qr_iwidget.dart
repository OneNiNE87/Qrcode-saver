import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
class Qrwidget extends StatefulWidget {
  @override
  _QrwidgetState createState() => _QrwidgetState();
}
class _QrwidgetState extends State<Qrwidget> {

  bool permissionGranted =false;
  final controller=ScreenshotController();
Future _getStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    setState(() {
      permissionGranted = true;
    });
  } else if (await Permission.storage.request().isPermanentlyDenied) {
    await openAppSettings();
  } else if (await Permission.storage.request().isDenied) {
    setState(() {
      permissionGranted = false;
    });
  }
}

Future<String> saveImage(Uint8List bytes) async{

    _getStoragePermission();
    final result = await ImageGallerySaver.saveImage(
      bytes,
      name: 'hello ',  /** here u can put your image name ,
                           you can much it with a DateTime.now() so every image will the unique name      */  
      );
      print(result);
    return result['filePath'];
}
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
            child:Screenshot( 
            controller: controller,
            child:QrImage(
              backgroundColor: Colors.white,
                   data: 'Saving Qr code with screenshot ^_^',
                   version: QrVersions.auto,
                   size: 320,
                   gapless: false,
                  ),
                ),
          ),
          SizedBox(
            height: 30,
          ),
          FloatingActionButton(onPressed:()async{
     final image= await controller.capture();
     if(image ==null) return; 
       await saveImage(image);
     },
    backgroundColor: Colors.blueGrey,
    child: Icon(
      Icons.download,
      color:Colors.greenAccent,
    ),)
        ],
      ),
    );
  }
}

 
