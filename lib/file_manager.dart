import 'dart:async';
import 'dart:collection';
import 'dart:math';

enum StatusEvent { loading, loaded, queued }

class Files {
  late String id;
  late StatusEvent status;

  Files(this.id, this.status);
}

class FileManager {
  var _currentlyLoading = <Files>[];
  var _queue = Queue<Files>();
  var _loadedFile = <Files>[];

  StreamController<List<Files>> _controller = StreamController<List<Files>>();
  late Stream<List<Files>> stream;

  FileManager() {
    stream = _controller.stream;
  }
  _updateStreamFile(){
    _controller.add(_currentlyLoading + _queue.toList() + _loadedFile);

  }

  // FileManager() {
  //   _inputEventController.stream.listen((event) { });
  // }


  addFile() {
    Files _newFile = Files(generateRandomString(5), StatusEvent.queued);
    if (_canLoadMoreFiles()) {
      _loadFile(_newFile);
    }
    // else if(_countFile()== false) {
    //   print('too many files');}
      else{_queue.add(_newFile);}
    _updateStreamFile();
  }

  _loadFile(Files _file) {
    _file.status = StatusEvent.loading;
    _currentlyLoading.add(_file);
    _fakeLoadFile(_file);
  }

  _fakeLoadFile(Files _fileToLoad) {
    random(min, max) {
      var rn = new Random();
      return min + rn.nextInt(max - min);
    }
    Duration delay = Duration(seconds: random(3, 10));
    Timer(delay, () {
      Files? _fileToUpdate =
          _currentlyLoading.firstWhere((file) => file.id == _fileToLoad.id);
      _currentlyLoading.remove(_fileToUpdate);
      _fileToUpdate.status = StatusEvent.loaded;
      _loadedFile.add(_fileToUpdate);
      _checkQueuedFiles();
      _updateStreamFile();
    });
  }

  _checkQueuedFiles(){
    if(_canLoadMoreFiles() && _queue.isNotEmpty){
      Files _fileToLoad = _queue.removeFirst();
      _loadFile(_fileToLoad);
      _updateStreamFile();
    }
  }

  bool _canLoadMoreFiles() {
    return _currentlyLoading.length < 3;
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  // _countFile(){
  //   if(_currentlyLoading.length + _queue.length + _loadedFile.length == 30)
  //     return false;
  //
  //
  // }

  update() {
    _updateStreamFile();
  }
  clear(){
    _currentlyLoading.clear();
    _loadedFile.clear();
    _queue.clear();
    update();
  }
}
