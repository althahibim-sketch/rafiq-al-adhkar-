import 'package:flutter/material.dart';
import 'package:app_1/core/theme/app_theme.dart';
import 'package:app_1/data/adhkar_data.dart';
import 'package:app_1/models/dhikr_item.dart';
import 'package:app_1/services/app_store.dart';
import 'package:app_1/widgets/dhikr_card.dart';
import 'package:app_1/widgets/empty_state.dart';

class DhikrSearchDelegate extends SearchDelegate<DhikrItem?> {
  final AppStore store;

  DhikrSearchDelegate({required this.store})
      : super(
          searchFieldLabel: 'ابحث في الأذكار...',
          keyboardType: TextInputType.text,
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF0D221C) : brandGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          tooltip: 'مسح',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'رجوع',
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final cleanQuery = query.trim().toLowerCase();
    final results = allAdhkar.where((item) {
      if (cleanQuery.isEmpty) return true;
      return item.title.toLowerCase().contains(cleanQuery) ||
          item.text.toLowerCase().contains(cleanQuery) ||
          item.source.toLowerCase().contains(cleanQuery) ||
          item.note.toLowerCase().contains(cleanQuery);
    }).toList();

    if (results.isEmpty) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: const EmptyState(
          icon: Icons.search_off,
          message: 'لم يتم العثور على أذكار مطابقة',
          detail: 'جرب كتابة كلمة أخرى مثل "استغفار" أو "حفظ".',
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: results.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            DhikrCard(item: results[index], store: store),
      ),
    );
  }
}
