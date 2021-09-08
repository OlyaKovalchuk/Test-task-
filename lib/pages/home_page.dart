import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../file_manager.dart';

class MenuItem extends StatefulWidget {
  const MenuItem({Key? key}) : super(key: key);

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  FileManager _fileManager = FileManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'File',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
          initialData: _fileManager.allFiles,
          stream: _fileManager.outputStateStream,
          builder: (context, AsyncSnapshot<List<Files>> snapshot) {
            return Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'File loading',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        _textLoadedFiles(),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'currently loading: ${_fileManager.currentlyLoading.length}',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/file');
                            },
                            child: Text('Menu Item')),
                        ElevatedButton(
                          onPressed: _saveButton(),
                          child: Text(
                            'Save',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _resetButton(),
                          child: Text('Reset'),
                        ),
                      ],
                    )));
          }),
    );
  }

  Text _textLoadedFiles() {
    if (_fileManager.loadedFile.length == 0) {
      return Text(
        'No files',
        style: Theme.of(context).textTheme.subtitle1,
      );
    } else {
      return Text(
        'All files: ${_fileManager.loadedFile.length}',
        style: Theme.of(context).textTheme.subtitle1,
      );
    }
  }

  _saveButton() {
    if (_checkLoadedFiles()) {
      return null;
    } else {
      return () {
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You saved files'),
          backgroundColor: Colors.green,
        ));
      };
    }
  }

  bool _checkLoadedFiles() => _fileManager.loadedFile.length == 0;

  _resetButton() {
    if (_checkLoadedFiles()) {
      return null;
    } else {
      return () {
        _fileManager.clearFile();
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You deleted files'),
          backgroundColor: Colors.red,
        ));
      };
    }
  }
}
