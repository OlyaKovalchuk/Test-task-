import 'package:flutter/material.dart';
import 'package:task/file_manager.dart';

class FilesProgress extends StatefulWidget {
  const FilesProgress({Key? key}) : super(key: key);

  @override
  _FilesProgressState createState() => _FilesProgressState();
}

class _FilesProgressState extends State<FilesProgress> {
  final _fileManager = FileManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add), onPressed: () => _isClicked()),
        body: StreamBuilder(
          initialData: <Files>[],
          stream: _fileManager.outputStateStream,
          builder: (context, AsyncSnapshot<List<Files>> snapshot) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) => ListBody(
                      children: [
                        ListTile(
                          title: Text(snapshot.data![index].id),
                          subtitle: Text(snapshot.data![index].status),
                        )
                      ],
                    ));
          },
        ));
  }

  _isClicked() {
    if (_fileManager.numOfLoadedFiles +
            _fileManager.numOfLoadingFiles +
            _fileManager.numOfQueuedFiles >=
        30) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You can't add more than 30 files "),
        backgroundColor: Colors.red,
      ));
      return null;
    } else {
      _fileManager.addFile();
    }
  }
}
