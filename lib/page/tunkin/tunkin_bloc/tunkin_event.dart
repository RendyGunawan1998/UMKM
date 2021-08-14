part of 'tunkin_bloc.dart';

abstract class TunkinEvent extends Equatable {
  const TunkinEvent();

  @override
  List<Object> get props => [];
}

class TunkinFetch extends TunkinEvent {
  final String tahun, bulan;

  TunkinFetch({@required this.bulan, this.tahun});
  @override
  String toString() => 'Fetch Tunkin Event';
}

class TunkinUpdate extends TunkinEvent {
  final String tahun, bulan;

  TunkinUpdate({@required this.bulan, this.tahun});
  @override
  String toString() => 'Update Tunkin Event';
}
