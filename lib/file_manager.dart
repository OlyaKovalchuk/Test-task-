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
  var currentlyLoading = <Files>[];
  var queue = Queue<Files>();
  var loadedFile = <Files>[];

  List<Files> get allFiles => currentlyLoading + queue.toList() + loadedFile;

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
    _outputStateController.add(currentlyLoading + queue.toList() + loadedFile);
  }

  addFile() {
    Files _newFile =
        Files(_generateRandomString(5), StatusEvent.queued, 'Queued');
    if (_canLoadMoreFiles()) {
      _loadFile(_newFile);
    } else {
      queue.add(_newFile);
      _newFile.status = 'Queued';
    }
    _updateStreamFile();
  }

  _loadFile(Files _file) {
    _file.statusEvent = StatusEvent.loading;
    _file.status = 'Loading';
    currentlyLoading.add(_file);
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
          currentlyLoading.firstWhere((file) => file.id == _fileToLoad.id);
      currentlyLoading.remove(_fileToUpdate);
      _fileToUpdate.statusEvent = StatusEvent.loaded;
      _fileToUpdate.status = 'Loaded';
      loadedFile.add(_fileToUpdate);
      _checkQueuedFiles();
      _updateStreamFile();
    });
  }

  _checkQueuedFiles() {
    if (_canLoadMoreFiles() && queue.isNotEmpty) {
      Files _fileToLoad = queue.removeFirst();
      _loadFile(_fileToLoad);
      _updateStreamFile();
    }
  }

  bool _canLoadMoreFiles() {
    return currentlyLoading.length < 3;
  }

  String _generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  delete(Files _fileToDelete) {
    if (_fileToDelete.statusEvent == StatusEvent.loaded) {
      loadedFile.remove(_fileToDelete);
    } else if (_fileToDelete.statusEvent == StatusEvent.loading) {
      currentlyLoading.remove(_fileToDelete);
    } else {
      queue.remove(_fileToDelete);
    }
    _updateStreamFile();
  }

  update() {
    _updateStreamFile();
  }

  clearFile() {
    loadedFile.clear();
    currentlyLoading.clear();
    queue.clear();
    _updateStreamFile();
  }
}
