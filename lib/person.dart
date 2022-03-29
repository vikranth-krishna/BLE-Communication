import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
part 'person.g.dart';

@JsonSerializable(explicitToJson: true)
class Person {
  String type;
  int number;
  String testId;
  String rgbValues;
  String rawValues;
  String calibratedValues;
  int length;

  Person(this.type, this.number, this.testId, this.rgbValues, this.rawValues, this.calibratedValues, this.length);


  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  Map<String, dynamic> toJson() => _$PersonToJson(this);

  @override
  String toString() =>
      'Person{type: $type,number: $number,testId: $testId,rgbValues: $rgbValues,rawValues: $rawValues,calibratedValues:$calibratedValues,@: $length,}';

}