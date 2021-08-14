part of 'gaji_bloc.dart';

abstract class GajiState extends Equatable {
  const GajiState();

  @override
  List<Object> get props => [];
}

class GajiLoading extends GajiState {}

// #================DIFFERENT==============#
// #================ERROR==============#

class GajiOnFailure extends GajiState {
  final ErrorModel dataError;

  const GajiOnFailure({this.dataError});

  @override
  List<Object> get props => [dataError];

  @override
  String toString() => 'GajiOnFailure { items: ${dataError.message} }';
}

// #================DIFFERENT==============#
// #================LOAD SUCCESS==============#

class GajiDataLoaded extends GajiState {
  final List<UserInfoData> dataList;

  const GajiDataLoaded({@required this.dataList});

  @override
  List<Object> get props => [dataList];
}
