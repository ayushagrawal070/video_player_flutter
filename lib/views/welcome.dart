import 'package:auth_practice/helper/helperfunctions.dart';
import 'package:auth_practice/views/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  bool isLoading = false;
  VideoPlayerController _controller;
  int _playbackTime = 0;
  double _volume = 0.5;
  String videoUrl;
  String dropdownValue = '360p';
  FirebaseStorage ref;
  Map dataImported;

  // loadJson() async {
  //   String data =
  //       await DefaultAssetBundle.of(context).loadString("images/test.json");
  //   final jsonResult = json.decode(data);
  //   print(jsonResult);
  //   // print(jsonResult['data'][0]['link']["360p"]);
  //   videoUrl = jsonResult['data'][0]['link']["360p"];
  // }

  loadFromFirebase(String resolution) async {
    setState(() {
      isLoading = true;
    });
    FirebaseOptions firebaseOptions = FirebaseOptions(
      appId: '1:558296203795:android:22732c637330b9d715f5e6',
      messagingSenderId: '558296203795',
      apiKey: 'AIzaSyAty4qMnAQMcQOtjGHbBDc7xJYXA2bK3Rw',
      projectId: 'authpract-9631e',
    );

    FirebaseApp app =
    await Firebase.initializeApp(name: 'ayushhfhdshh', options: firebaseOptions);

    FirebaseStorage storage = FirebaseStorage(
        app: app, storageBucket: 'gs://authpract-9631e.appspot.com');
    StorageReference ref =
    storage.ref().child('test2.json');
    String url = await ref.getDownloadURL();
    print(url);
    http.Response downloadData = await http.get(url);
    dataImported = jsonDecode(downloadData.body);
    print(dataImported);
    videoUrl = dataImported['data'][0]['link'][resolution];
    app.delete();
  }

  PlayVideofunction(String resolution){
    loadFromFirebase(resolution).then((val) {
      print(videoUrl);
      _controller = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {
            isLoading = false;
          });
        });
      _controller.addListener(() {
        setState(() {
          _playbackTime = _controller.value.position.inSeconds;
          _volume = _controller.value.volume;
        });
      });
    });
  }

  @override
  void initState() {
    PlayVideofunction(dropdownValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player Screen'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          GestureDetector(
            onTap: () {
              HelperFunctions.saveUserLoggedInSharedPreference(false);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          VPlayer(),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: Text(
              "Seek Bar : ",
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Slider(
            value: _playbackTime.toDouble(),
            max: _controller.value.duration.inSeconds.toDouble(),
            min: 0,
            onChanged: (v) {
              _controller.seekTo(Duration(seconds: v.toInt()));
            },
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: Text(
              "Volume Bar : ",
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Slider(
            value: _volume,
            max: 1,
            min: 0,
            onChanged: (v) {
              _controller.setVolume(v);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  "Choose Resolution",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                    PlayVideofunction(dropdownValue);
                  });
                },
                items: <String>['360p', '480p', '720p', '1080p']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(
                      color: Colors.green[900],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                  );
                }).toList(),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  Widget VPlayer(){
    return Center(
      child: _controller.value.initialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


}
