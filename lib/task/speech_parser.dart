import 'package:flutter/material.dart';

class ParsedTask {
  final String title;
  final String description;
  final DateTime? date;
  final TimeOfDay? time;

  ParsedTask({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
  });
}

ParsedTask parseSpokenTask(String rawText) {
  final text = rawText.toLowerCase().trim();

  final relativeDateTime = _extractRelativeDateTime(text);
  final date = relativeDateTime?.date ?? _extractDate(text) ?? DateTime.now();
  final time = relativeDateTime?.time ?? _extractTime(text) ?? const TimeOfDay(hour: 9, minute: 0);

  return ParsedTask(
    title: _extractTitle(text),
    description: rawText,
    date: date,
    time: time,
  );
}

class _RelativeResult {
  final DateTime? date;
  final TimeOfDay? time;

  _RelativeResult({this.date, this.time});
}

_RelativeResult? _extractRelativeDateTime(String text) {
  final now = DateTime.now();
  DateTime? date;
  TimeOfDay? time;

  final dayRegex = RegExp(r'(\d+)\s*gün sonra');
  final weekRegex = RegExp(r'(\d+)\s*hafta sonra');
  final monthRegex = RegExp(r'(\d+)\s*ay sonra');

  final dayMatch = dayRegex.firstMatch(text);
  if (dayMatch != null) {
    final days = int.parse(dayMatch.group(1)!);
    date = now.add(Duration(days: days));
  }

  final weekMatch = weekRegex.firstMatch(text);
  if (weekMatch != null) {
    final weeks = int.parse(weekMatch.group(1)!);
    date = now.add(Duration(days: weeks * 7));
  }

  final monthMatch = monthRegex.firstMatch(text);
  if (monthMatch != null) {
    final months = int.parse(monthMatch.group(1)!);
    date = DateTime(now.year, now.month + months, now.day);
  }

  final hourRegex = RegExp(r'(\d{1,2})\s*(?:saat)?');
  final minuteRegex = RegExp(r'(\d+)\s*dakika');

  final hourMatch = hourRegex.firstMatch(text);
  if (hourMatch != null) {
    int hour = int.parse(hourMatch.group(1)!);
    int minute = 0;

    final minuteMatch = minuteRegex.firstMatch(text);
    if (minuteMatch != null) {
      minute = int.parse(minuteMatch.group(1)!);
    }

    if (text.contains('öğleden sonra') ||
        text.contains('akşam') ||
        text.contains('gece')) {
      if (hour < 12) hour += 12;
    }

    if (text.contains('öğleden önce') || text.contains('sabah')) {
      if (hour == 12) hour = 0;
    }

    time = TimeOfDay(hour: hour, minute: minute);
  }

  return _RelativeResult(date: date, time: time);
}

DateTime? _extractDate(String text) {
  final now = DateTime.now();

  if (text.contains('bugün')) return DateTime(now.year, now.month, now.day);
  if (text.contains('yarın')) return DateTime(now.year, now.month, now.day + 1);
  if (text.contains('öbür gün')) return DateTime(now.year, now.month, now.day + 2);

  // Haftanın günleri
  final weekdays = {
    'pazartesi': DateTime.monday,
    'salı': DateTime.tuesday,
    'çarşamba': DateTime.wednesday,
    'perşembe': DateTime.thursday,
    'cuma': DateTime.friday,
    'cumartesi': DateTime.saturday,
    'pazar': DateTime.sunday,
  };

  for (final entry in weekdays.entries) {
    if (text.contains(entry.key)) {
      int diff = entry.value - now.weekday;
      if (diff <= 0) diff += 7;
      final d = now.add(Duration(days: diff));
      return DateTime(d.year, d.month, d.day);
    }
  }

  final monthMap = {
    'ocak': 1,
    'şubat': 2,
    'mart': 3,
    'nisan': 4,
    'mayıs': 5,
    'haziran': 6,
    'temmuz': 7,
    'ağustos': 8,
    'eylül': 9,
    'ekim': 10,
    'kasım': 11,
    'aralık': 12,
  };

  final dateMatch = RegExp(r'(\d{1,2})\s+(ocak|şubat|mart|nisan|mayıs|haziran|temmuz|ağustos|eylül|ekim|kasım|aralık)').firstMatch(text);
  if (dateMatch != null) {
    final day = int.parse(dateMatch.group(1)!);
    final month = monthMap[dateMatch.group(2)!]!;
    return DateTime(now.year, month, day);
  }
  return null;
}

TimeOfDay? _extractTime(String text) {
  final timeRegex = RegExp(r'(\d{1,2})(?:[:.](\d{2}))?'); // 4 veya 16 gibi sayıları yakalar
  final match = timeRegex.firstMatch(text);

  if (match == null) return null;

  int hour = int.parse(match.group(1)!);
  int minute = match.group(2) != null ? int.parse(match.group(2)!) : 0;

  if (text.contains('öğleden sonra') && hour < 12) {
    hour += 12;
  }
  if (text.contains('akşam') && hour < 12) {
    hour += 12;
  }
  if (text.contains('gece') && hour < 12) {
    hour += 12;
  }
  if (text.contains('sabah') && hour == 12) {
    hour = 0;
  }
  if (text.contains('öğleden önce') && hour == 12) {
    hour = 0;
  }

  if (hour > 23 || minute > 59) return null;

  return TimeOfDay(hour: hour, minute: minute);
}

String _extractTitle(String text) {
  final taskTypes = {
    'toplantı': 'Toplantı',
    'görüşme': 'Görüşme',
    'sunum': 'Sunum',
    'rapor': 'Rapor',
    'alışveriş': 'Alışveriş',
    'temizlik': 'Temizlik',
    'spor': 'Spor',
    'egzersiz': 'Egzersiz',
    'kitap': 'Kitap',
    'film': 'Film',
    'randevu': 'Randevu',
  };

  for (final key in taskTypes.keys) {
    if (text.contains(key)) return taskTypes[key]!;
  }

  final words = text.split(' ').where((w) => w.length > 3).toList();
  return words.isNotEmpty ? words.take(3).join(' ') : 'New Task';
}
