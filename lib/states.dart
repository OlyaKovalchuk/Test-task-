import 'package:equatable/equatable.dart';
import 'package:task/file_manager.dart';

abstract class FilesState extends Equatable{}
class EmptyState extends FilesState{
  @override
  List<Object?> get props => [];

}


class OnPressedButton extends FilesState{
 late final List<Files> files;
 OnPressedButton(this.files);
  @override
  List<Object?> get props => [files];

}


class ErrorState extends FilesState{
  @override
  List<Object?> get props =>[];

}