import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'proposals_record.g.dart';

abstract class ProposalsRecord
    implements Built<ProposalsRecord, ProposalsRecordBuilder> {
  static Serializer<ProposalsRecord> get serializer =>
      _$proposalsRecordSerializer;

  @nullable
  LatLng get location;

  @nullable
  String get frequency;

  @nullable
  BuiltList<String> get types;

  @nullable
  String get hostId;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(ProposalsRecordBuilder builder) => builder
    ..frequency = ''
    ..types = ListBuilder()
    ..hostId = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('proposals');

  static Stream<ProposalsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  static Future<ProposalsRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s)));

  ProposalsRecord._();
  factory ProposalsRecord([void Function(ProposalsRecordBuilder) updates]) =
      _$ProposalsRecord;

  static ProposalsRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createProposalsRecordData({
  LatLng location,
  String frequency,
  String hostId,
}) =>
    serializers.toFirestore(
        ProposalsRecord.serializer,
        ProposalsRecord((p) => p
          ..location = location
          ..frequency = frequency
          ..types = null
          ..hostId = hostId));
