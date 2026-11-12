// بيانات الذكر: النص والعدد والمصدر ومعرّف ثابت للحفظ والمفضلة.
class DhikrItem {
  final String id;
  final String title;
  final String text;
  final int target;
  final String source;
  final String note;

  const DhikrItem({
    required this.id,
    required this.title,
    required this.text,
    required this.target,
    required this.source,
    this.note = '',
  });
}
