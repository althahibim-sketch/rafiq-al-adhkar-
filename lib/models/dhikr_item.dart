// بيانات الذكر: النص والعدد والمصدر وفضل الذكر ومعرّف ثابت للحفظ والتخزين.
class DhikrItem {
  final String id;
  final String title;
  final String text;
  final int target;
  final String source;
  final String note;
  final String virtue; // فضل الذكر وثوابه
  final String category; // تصنيف الذكر
  final bool isCustom; // هل أضافه المستخدم

  const DhikrItem({
    required this.id,
    required this.title,
    required this.text,
    required this.target,
    required this.source,
    this.note = '',
    this.virtue = '',
    this.category = '',
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'text': text,
        'target': target,
        'source': source,
        'note': note,
        'virtue': virtue,
        'category': category,
        'isCustom': isCustom,
      };

  factory DhikrItem.fromJson(Map<String, dynamic> json) {
    return DhikrItem(
      id: json['id'] as String,
      title: json['title'] as String,
      text: json['text'] as String,
      target: (json['target'] as num?)?.toInt() ?? 1,
      source: (json['source'] as String?) ?? '',
      note: (json['note'] as String?) ?? '',
      virtue: (json['virtue'] as String?) ?? '',
      category: (json['category'] as String?) ?? '',
      isCustom: (json['isCustom'] as bool?) ?? false,
    );
  }
}
