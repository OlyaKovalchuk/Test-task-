import 'file_manager.dart';

class  FilesRepository{
  final  fileManager = FileManager();
FilesRepository();

fetchFiles(){
  final files = <Files>[];
  return fileManager.addFile();
}
}