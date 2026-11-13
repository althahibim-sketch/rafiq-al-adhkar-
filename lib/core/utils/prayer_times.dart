import 'dart:math';

/// نموذج بيانات وقت الصلاة
class PrayerTime {
  final String name;
  final DateTime time;
  final String arabicName;

  PrayerTime({
    required this.name,
    required this.time,
    required this.arabicName,
  });

  String format12Hour() {
    int hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    return '$hour:$minute $period';
  }
}

/// معلومات المدينة والإحداثيات
class CityLocation {
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  final double timezone;

  const CityLocation({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  static const List<CityLocation> defaultCities = [
    CityLocation(name: 'الرياض', country: 'السعودية', latitude: 24.7136, longitude: 46.6753, timezone: 3),
    CityLocation(name: 'مكة المكرمة', country: 'السعودية', latitude: 21.3891, longitude: 39.8579, timezone: 3),
    CityLocation(name: 'المدينة المنورة', country: 'السعودية', latitude: 24.5247, longitude: 39.5692, timezone: 3),
    CityLocation(name: 'القاهرة', country: 'مصر', latitude: 30.0444, longitude: 31.2357, timezone: 2),
    CityLocation(name: 'دبي', country: 'الإمارات', latitude: 25.2048, longitude: 55.2708, timezone: 4),
    CityLocation(name: 'الكويت', country: 'الكويت', latitude: 29.3759, longitude: 47.9774, timezone: 3),
    CityLocation(name: 'الدوحة', country: 'قطر', latitude: 25.2854, longitude: 51.5310, timezone: 3),
    CityLocation(name: 'المنامة', country: 'البحرين', latitude: 26.2285, longitude: 50.5860, timezone: 3),
    CityLocation(name: 'مسقط', country: 'عمان', latitude: 23.5880, longitude: 58.3829, timezone: 4),
    CityLocation(name: 'عَمّان', country: 'الأردن', latitude: 31.9454, longitude: 35.9284, timezone: 3),
    CityLocation(name: 'القدس الشريف', country: 'فلسطين', latitude: 31.7683, longitude: 35.2137, timezone: 2),
    CityLocation(name: 'بغداد', country: 'العراق', latitude: 33.3152, longitude: 44.3661, timezone: 3),
    CityLocation(name: 'دمشق', country: 'سوريا', latitude: 33.5138, longitude: 36.2765, timezone: 3),
    CityLocation(name: 'بيروت', country: 'لبنان', latitude: 33.8938, longitude: 35.5018, timezone: 2),
    CityLocation(name: 'صنعاء', country: 'اليمن', latitude: 15.3694, longitude: 44.1910, timezone: 3),
    CityLocation(name: 'طرابلس', country: 'ليبيا', latitude: 32.8872, longitude: 13.1913, timezone: 2),
    CityLocation(name: 'تونس', country: 'تونس', latitude: 36.8065, longitude: 10.1815, timezone: 1),
    CityLocation(name: 'الجزائر', country: 'الجزائر', latitude: 36.7538, longitude: 3.0588, timezone: 1),
    CityLocation(name: 'الرباط', country: 'المغرب', latitude: 34.0209, longitude: -6.8416, timezone: 1),
  ];
}

/// حاسبة مواقيت الصلاة الفلكية والقبلة
class PrayerTimesCalculator {
  // إحداثيات الكعبة المشرفة في مكة المكرمة
  static const double meccaLat = 21.422487;
  static const double meccaLng = 39.826206;

  /// حساب زاوية اتجاه القبلة بالنسبة للشمال الحقيقي (0-360 درجة)
  static double calculateQiblaDirection(double lat, double lng) {
    final phiK = meccaLat * pi / 180.0;
    final lambdaK = meccaLng * pi / 180.0;
    final phi = lat * pi / 180.0;
    final lambda = lng * pi / 180.0;

    final numerator = sin(lambdaK - lambda);
    final denominator = cos(phi) * tan(phiK) - sin(phi) * cos(lambdaK - lambda);
    double qibla = atan2(numerator, denominator) * 180.0 / pi;

    if (qibla < 0) {
      qibla += 360.0;
    }
    return qibla;
  }

  /// حساب مواقيت الصلوات الخمس والشروق ليوم معين
  static List<PrayerTime> calculate(DateTime date, CityLocation city) {
    final int year = date.year;
    final int month = date.month;
    final int day = date.day;

    final double lat = city.latitude;
    final double lng = city.longitude;
    final double tz = city.timezone;

    // اليوم في السنة (Julian Day approx)
    final double d = (367.0 * year - (7.0 * (year + ((month + 9) ~/ 12))) ~/ 4 + (275 * month) ~/ 9 + day - 730531.5);
    final double L = (280.461 + 0.9856474 * d) % 360;
    final double M = (357.528 + 0.9856003 * d) % 360;
    final double lambda = (L + 1.915 * sin(M * pi / 180) + 0.020 * sin(2 * M * pi / 180)) % 360;
    final double obliquity = 23.439 - 0.0000004 * d;
    final double alpha = atan2(cos(obliquity * pi / 180) * sin(lambda * pi / 180), cos(lambda * pi / 180)) * 180 / pi;

    // معادلة الوقت وميل الشمس
    final double eqTime = (L / 15.0 - (alpha % 360) / 15.0) * 60.0;
    final double declination = asin(sin(obliquity * pi / 180) * sin(lambda * pi / 180)) * 180 / pi;

    // زوال الشمس (الظهر)
    final double noonMinutes = 12.0 * 60.0 - eqTime - (lng - tz * 15.0) * 4.0;

    // الفجر والشروق والمغرب والعشاء
    // زاوية الفجر المعتمدة 18.5 درجة
    final double fajrAngle = -18.5;
    final double fajrHourAngle = _hourAngle(lat, declination, fajrAngle);
    final double sunriseHourAngle = _hourAngle(lat, declination, -0.8333);

    // زاوية العصر (ظل المثل + ظل الزوال)
    final double asrAltitude = atan(1.0 / (1.0 + tan((lat - declination).abs() * pi / 180))) * 180 / pi;
    final double asrHourAngle = _hourAngle(lat, declination, asrAltitude);

    // حساب الدقائق لكل صلاة
    final double fajrM = noonMinutes - fajrHourAngle * 4.0;
    final double sunriseM = noonMinutes - sunriseHourAngle * 4.0;
    final double dhuhrM = noonMinutes;
    final double asrM = noonMinutes + asrHourAngle * 4.0;
    final double maghribM = noonMinutes + sunriseHourAngle * 4.0;
    // العشاء: 90 دقيقة بعد المغرب أو زاوية 18 درجة
    final double ishaM = maghribM + 90.0;

    return [
      PrayerTime(name: 'fajr', arabicName: 'الفجر', time: _toDateTime(date, fajrM)),
      PrayerTime(name: 'sunrise', arabicName: 'الشروق', time: _toDateTime(date, sunriseM)),
      PrayerTime(name: 'dhuhr', arabicName: 'الظهر', time: _toDateTime(date, dhuhrM)),
      PrayerTime(name: 'asr', arabicName: 'العصر', time: _toDateTime(date, asrM)),
      PrayerTime(name: 'maghrib', arabicName: 'المغرب', time: _toDateTime(date, maghribM)),
      PrayerTime(name: 'isha', arabicName: 'العشاء', time: _toDateTime(date, ishaM)),
    ];
  }

  static double _hourAngle(double lat, double dec, double alt) {
    final double latRad = lat * pi / 180;
    final double decRad = dec * pi / 180;
    final double altRad = alt * pi / 180;
    final double cosHA = (sin(altRad) - sin(latRad) * sin(decRad)) / (cos(latRad) * cos(decRad));
    final double clamped = cosHA.clamp(-1.0, 1.0);
    return acos(clamped) * 180 / pi;
  }

  static DateTime _toDateTime(DateTime base, double minutesFromMidnight) {
    int totalM = minutesFromMidnight.round();
    while (totalM < 0) {
      totalM += 1440;
    }
    totalM = totalM % 1440;
    final int h = totalM ~/ 60;
    final int m = totalM % 60;
    return DateTime(base.year, base.month, base.day, h, m);
  }

  /// معرفة الصلاة القادمة والوقت المتبقي لها
  static Map<String, dynamic> getNextPrayer(List<PrayerTime> prayers) {
    final now = DateTime.now();
    for (final p in prayers) {
      if (p.name == 'sunrise') continue; // الشروق ليس صلاة مفروضة
      if (p.time.isAfter(now)) {
        final diff = p.time.difference(now);
        final hours = diff.inHours;
        final minutes = diff.inMinutes % 60;
        final timeRemaining = hours > 0 ? '$hours س و $minutes د' : '$minutes دقيقة';
        return {
          'prayer': p,
          'remaining': timeRemaining,
        };
      }
    }
    // إذا انتهت صلوات اليوم، فالصلاة القادمة فجر الغد
    final fajr = prayers.firstWhere((p) => p.name == 'fajr');
    final tomorrowFajr = fajr.time.add(const Duration(days: 1));
    final diff = tomorrowFajr.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    return {
      'prayer': fajr,
      'remaining': '$hours س و $minutes د',
    };
  }
}
