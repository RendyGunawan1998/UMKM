part of 'tunkin_bloc.dart';

abstract class TunkinState extends Equatable {
  const TunkinState();

  @override
  List<Object> get props => [];
}

// #================DIFFERENT==============#
// #=================LAODING===============#

class TunkinLoading extends TunkinState {}

// #================DIFFERENT==============#
// #==================ERROR================#

class TunkinOnFailure extends TunkinState {
  final ErrorModel dataError;

  const TunkinOnFailure({this.dataError});

  @override
  List<Object> get props => [dataError];

  @override
  String toString() => 'TunkinOnFailure { items: ${dataError.message} }';
}

// #================DIFFERENT==============#
// #==============LOAD SUCCESS=============#

class TunkinDataLoaded extends TunkinState {
  final List<Tunkin> tunkin;

  const TunkinDataLoaded({@required this.tunkin});

  @override
  List<Object> get props => [tunkin];
}
