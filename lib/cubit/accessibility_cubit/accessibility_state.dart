import 'package:equatable/equatable.dart';

class AccessibilityState extends Equatable {
  final double textScaleFactor;

  const AccessibilityState({
    this.textScaleFactor = 1.0,
  });

  @override
  List<Object?> get props => [textScaleFactor];

  AccessibilityState copyWith({double? textScaleFactor}) {
    return AccessibilityState(
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    );
  }
}