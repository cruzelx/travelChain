import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class VideoRecorder extends StatefulWidget {
  @override
  _VideoRecorderState createState() => _VideoRecorderState();
}

class _VideoRecorderState extends State<VideoRecorder> {
  CameraController _cameraController;
  Future<void> _initFutureCam;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  _initApp() async {
    final cameras = await availableCameras();
    final firstCam = cameras.first;
    _cameraController = CameraController(
      firstCam,
      ResolutionPreset.medium,
    );
    _initFutureCam = _cameraController.initialize();
    print(_initFutureCam);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Record Video"),
      ),
      body: FutureBuilder<void>(future: _initFutureCam,builder:(context, snapshot){
        if(snapshot.hasData){
        return CameraPreview(_cameraController);
        }else{
          return Center(child: CircularProgressIndicator());
        }
      }
       ),
       floatingActionButton: FloatingActionButton(
        child: Icon(Icons.videocam),
        onPressed: ()async{
          try{
            await _initFutureCam;
            final path =  join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.mp4',
            );
            await _cameraController.startVideoRecording(path);
            print(path);
          }catch(e){
            print(e);
          }
        },
       ),
    );
  }
}
