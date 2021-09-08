import 'dart:async';
import 'dart:collection';
import 'dart:math';

enum StatusEvent { loading, loaded, queued }

class Files {
  late String id;
  late StatusEvent statusEvent;
  late String status;

  Files(this.id, this.statusEvent, this.status);
}

class FileManager {
  int numOfLoadedFiles = 0;
  int numOfLoadingFiles = 0;
  int numOfQueuedFiles = 0;
  var _currentlyLoading = <Files>[];
  var _queue = Queue<Files>();
  var loadedFile = <Files>[];

  List<Files> get allFiles => _currentlyLoading + _queue.toList() + loadedFile;

  final _inputEventController = StreamController<StatusEvent>();

  StreamSink<StatusEvent> get inputEventSink => _inputEventController.sink;

  final _outputStateController = StreamController<List<Files>>.broadcast();

  Stream<List<Files>> get outputStateStream => _outputStateController.stream;

  FileManager._privateConstructor();

  static final FileManager _instance = FileManager._privateConstructor();

  factory FileManager() {
    return _instance;
  }

  void dispose() {
    _inputEventController.close();
    _outputStateController.close();
  }

  _updateStreamFile() {
    _outputStateController
        .add(_currentlyLoading + _queue.toList() + loadedFile);
  }

  addFile() {
    Files _newFile =
        Files(_generateRandomString(5), StatusEvent.queued, 'Queued');
    if (_canLoadMoreFiles()) {
      _loadFile(_newFile);
    } else {
      _queue.add(_newFile);
      _newFile.status = 'Queued';
      numOfQueuedFiles++;
    }
    _updateStreamFile();
  }

  _loadFile(Files _file) {
    _file.statusEvent = StatusEvent.loading;
    _file.status = 'Loading';
    _currentlyLoading.add(_file);
    numOfLoadingFiles++;
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
      numOfLoadingFiles--;
      _fileToUpdate.statusEvent = StatusEvent.loaded;
      _fileToUpdate.status = 'Loaded';
      loadedFile.add(_fileToUpdate);
      numOfLoadedFiles++;
      _checkQueuedFiles();
      _updateStreamFile();
    });
  }

  _checkQueuedFiles() {
    if (_canLoadMoreFiles() && _queue.isNotEmpty) {
      Files _fileToLoad = _queue.removeFirst();
      numOfQueuedFiles--;
      _loadFile(_fileToLoad);
      _updateStreamFile();
    }
  }

  bool _canLoadMoreFiles() {
    return _currentlyLoading.length < 3;
  }

  String _generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  delete(Files _fileToDelete) {
    if (_fileToDelete.statusEvent == StatusEvent.loaded) {
      loadedFile.remove(_fileToDelete);
      numOfLoadedFiles--;
    } else if (_fileToDelete.statusEvent == StatusEvent.loading) {
      _currentlyLoading.remove(_fileToDelete);
      numOfLoadingFiles--;
    } else {
      _queue.remove(_fileToDelete);
      numOfQueuedFiles--;
    }
    _updateStreamFile();
  }

  update() {
    _updateStreamFile();
  }

  clearFile() {
    loadedFile.clear();
    _currentlyLoading.clear();
    _queue.clear();
    numOfLoadedFiles = 0;
    numOfLoadingFiles = 0;
    numOfQueuedFiles = 0;
    _updateStreamFile();
  }
}
