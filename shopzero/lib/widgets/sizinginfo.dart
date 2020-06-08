import 'package:ShopZero/widgets/screentype.dart';
import 'package:flutter/cupertino.dart';

class SizingInformation {
  final Orientation orientation;
  final DeviceScreenType deviceScreenType;
  final Size screenSize;
  final Size localWidgetSize;

  SizingInformation({
    this.orientation,
    this.deviceScreenType,
    this.screenSize,
    this.localWidgetSize
  });

  @override 
  String toString() {
  return 'Orientation:$orientation deviceScreenType:$deviceScreenType screenSize: $screenSize localWidgetSize: $localWidgetSize';
   }
}