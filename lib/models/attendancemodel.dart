import 'dart:convert';

enum AttendanceStatus { Present, Incomplete, Absent }

class AttendanceRecord {
  DateTime date;
  DateTime? checkIn;
  DateTime? checkOut;

  AttendanceRecord({required this.date, this.checkIn, this.checkOut});

  AttendanceStatus get status {
    if (checkIn != null && checkOut != null) {
      return AttendanceStatus.Present;
    } else if (checkIn != null || checkOut != null) {
      return AttendanceStatus.Incomplete;
    } else {
      return AttendanceStatus.Absent;
    }
  }

  String get timeSpent {
    if (checkIn != null && checkOut != null) {
      final duration = checkOut!.difference(checkIn!);
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    }
    return '--:--';
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'checkIn': checkIn?.toIso8601String(),
      'checkOut': checkOut?.toIso8601String(),
    };
  }

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      date: DateTime.parse(map['date']),
      checkIn: map['checkIn'] != null ? DateTime.parse(map['checkIn']) : null,
      checkOut: map['checkOut'] != null
          ? DateTime.parse(map['checkOut'])
          : null,
    );
  }

  static String encode(List<AttendanceRecord> records) => json.encode(
    records.map<Map<String, dynamic>>((record) => record.toMap()).toList(),
  );

  static List<AttendanceRecord> decode(String records) =>
      (json.decode(records) as List<dynamic>)
          .map<AttendanceRecord>((item) => AttendanceRecord.fromMap(item))
          .toList();
}
