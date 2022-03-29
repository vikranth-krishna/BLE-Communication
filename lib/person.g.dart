// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      json['type'] as String,
      json['number'] as int,
      json['testId'] as String,
      json['rgbValues'] as String,
      json['rawValues'] as String,
      json['calibratedValues'] as String,
      json['length'] as int,
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'type': instance.type,
      'number': instance.number,
      'testId': instance.testId,
      'rgbValues': instance.rgbValues,
      'rawValues': instance.rawValues,
      'calibratedValues': instance.calibratedValues,
      'length': instance.length,
    };
