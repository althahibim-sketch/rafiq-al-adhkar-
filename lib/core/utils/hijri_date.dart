/// حاسبة تقريبية ودقيقة للتقويم الهجري بدون الحاجة إلى مكتبات خارجية أو اتصال بالإنترنت.
class HijriDate {
  final int year;
  final int month;
  final int day;

  HijriDate({required this.year, required this.month, required this.day});

  static const List<String> monthNames = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  String get monthName => monthNames[(month - 1).clamp(0, 11)];

  String formatFull() => '$day $monthName $year هـ';

  /// تحويل التاريخ الميلادي إلى التاريخ الهجري الحسابي المعتمد
  factory HijriDate.fromDate(DateTime date) {
    int day = date.day;
    int month = date.month;
    int year = date.year;

    int m = month;
    int y = year;
    if (m < 3) {
      y -= 1;
      m += 12;
    }

    int a = (y / 100).floor();
    int b = 2 - a + (a / 4).floor();
    int jd = (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        day +
        b -
        1524;

    int l = jd - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;
    int j = ((10985 - l) / 5316).floor() * ((50 * l) / 17719).floor() +
        (l / 5670).floor() * ((43 * l) / 15238).floor();
    l = l -
        ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() -
        (j / 16).floor() * ((15238 * j) / 43).floor() +
        29;
    m = ((24 * l) / 709).floor();
    int d = l - ((709 * m) / 24).floor();
    y = 30 * n + j - 30;

    return HijriDate(year: y, month: m, day: d);
  }
}
