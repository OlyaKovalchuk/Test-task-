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
          child: Text('Add File'),
          onPressed: () {
            _fileManager.addFile();
          }),
      body: StreamBuilder(
        initialData: <Files>[],
        stream: _fileManager.stream,
        builder:(context,AsyncSnapshot<List<Files>> snapshot){
          return ListView.builder(
            itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index)=>
              ListBody(children: [
                ListTile(
                  title: Text(snapshot.data![index].id),
                  subtitle: Text(snapshot.data![index].status.toString()),
                )
              ],)
          );
        }, 
      )

    );
  }
}
