part of 'gaji_bloc.dart';

abstract class GajiEvent extends Equatable {
  const GajiEvent();

  @override
  List<Object> get props => [];
}

class GajiFetch extends GajiEvent {
  final String tahun, bulan;

  GajiFetch({@required this.bulan, this.tahun});
  @override
  String toString() => 'Fetch Gaji Event';
}

class GajiUpdate extends GajiEvent {
  final String tahun, bulan;

  GajiUpdate({@required this.bulan, this.tahun});
  @override
  String toString() => 'Update Gaji Event';
}
