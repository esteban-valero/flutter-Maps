import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flashpark_client/verPerfil/components/EditPerfil.dart';
import 'package:flashpark_client/widgets/Provider_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Uploader extends StatefulWidget {
  final File file;
  Uploader({Key key, this.file}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  String url = "";

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://flashpark-8dd19.appspot.com/');

  StorageUploadTask _uploadTask;

  /// Starts an upload task

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
              children: [
                if (_uploadTask.isComplete) ...[
                  TextButton(
                      child: Text("Cerrar"),
                      onPressed: () async {
                        final uid =
                            await Provider.of(context).auth.getCurrentUID();
                        final ref = FirebaseStorage.instance
                            .ref()
                            .child("images/$uid.png");
                        var url = await ref.getDownloadURL();
                        print(url);
                        await Provider.of(context)
                            .db
                            .collection("users")
                            .doc(uid)
                            .update({'image': url}).then((_) {
                          print("Success!");
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPerfil(),
                          ),
                        );
                      }),
                ],

                if (_uploadTask.isPaused)
                  TextButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: _uploadTask.resume,
                  ),

                if (_uploadTask.isInProgress)
                  TextButton(
                    child: Icon(Icons.pause),
                    onPressed: _uploadTask.pause,
                  ),

                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
              ],
            );
          });
    } else {
      // Allows user to decide when to start the upload
      return TextButton.icon(
        label: Text('Cargar'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }
  }

  _startUpload() async {
    String uid = await Provider.of(context).auth.getCurrentUID();
    print(uid);

    /// Unique file name for the file

    String filePath = 'images/$uid.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }
}
