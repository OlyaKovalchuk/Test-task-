import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/file_manager.dart';
import 'package:task/file_repository.dart';
import 'package:task/states.dart';

class FilesCubit extends Cubit<FilesState>{
  FilesCubit({ required this.fileManager}) : super(EmptyState()){
    getFiles();
  }
final FileManager fileManager;
  void getFiles(){
    try{
      final files =<Files>[];
      emit(OnPressedButton(files));
    }catch(e){
      emit(ErrorState());
    }
  }

}