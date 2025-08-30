import 'package:equatable/equatable.dart';
class DetailEvent extends Equatable { const DetailEvent(); @override List<Object?> get props => []; }
class DetailStarted extends DetailEvent { final String handle; const DetailStarted(this.handle); @override List<Object?> get props => [handle]; }
