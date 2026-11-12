import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color brandGreen = Color(0xFF176B5B);
const Color brandGold = Color(0xFFD6AE45);
const Color pageBackground = Color(0xFFF5F7F2);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RafiqApp());
}

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

// النصوص المختارة هنا مرتبطة بمراجع محددة. يمكن إضافة أذكار أخرى
// لاحقاً بعد مراجعة النص والعدد والمصدر.
const List<DhikrItem> morningAdhkar = [
  DhikrItem(
    id: 'morning_sayyid',
    title: 'سيد الاستغفار',
    text: 'اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك، وأنا على عهدك ووعدك ما استطعت، أعوذ بك من شر ما صنعت، أبوء لك بنعمتك علي، وأبوء بذنبي، فاغفر لي، فإنه لا يغفر الذنوب إلا أنت.',
    target: 1,
    source: 'صحيح البخاري، حديث 6306',
    note: 'يقال مرة واحدة في الصباح.',
  ),
  DhikrItem(
    id: 'morning_protection',
    title: 'ذكر الحفظ',
    text: 'بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم.',
    target: 3,
    source: 'سنن أبي داود 5088، وجامع الترمذي 3388',
    note: 'يقال ثلاث مرات صباحاً.',
  ),
];

const List<DhikrItem> eveningAdhkar = [
  DhikrItem(
    id: 'evening_sayyid',
    title: 'سيد الاستغفار',
    text: 'اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك، وأنا على عهدك ووعدك ما استطعت، أعوذ بك من شر ما صنعت، أبوء لك بنعمتك علي، وأبوء بذنبي، فاغفر لي، فإنه لا يغفر الذنوب إلا أنت.',
    target: 1,
    source: 'صحيح البخاري، حديث 6306',
    note: 'يقال مرة واحدة في المساء.',
  ),
  DhikrItem(
    id: 'evening_protection',
    title: 'ذكر الحفظ',
    text: 'بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم.',
    target: 3,
    source: 'سنن أبي داود 5088، وجامع الترمذي 3388',
    note: 'يقال ثلاث مرات مساءً.',
  ),
];

const List<DhikrItem> sleepAdhkar = [
  DhikrItem(
    id: 'sleep_dua',
    title: 'دعاء النوم',
    text: 'باسمك اللهم أموت وأحيا.',
    target: 1,
    source: 'صحيح البخاري، حديث 6324',
    note: 'يقال عند الاضطجاع للنوم.',
  ),
];

const List<DhikrItem> prayerAdhkar = [
  DhikrItem(
    id: 'prayer_subhanallah',
    title: 'التسبيح',
    text: 'سبحان الله',
    target: 33,
    source: 'صحيح مسلم، حديث 596',
  ),
  DhikrItem(
    id: 'prayer_alhamdulillah',
    title: 'التحميد',
    text: 'الحمد لله',
    target: 33,
    source: 'صحيح مسلم، حديث 596',
  ),
  DhikrItem(
    id: 'prayer_allahuakbar',
    title: 'التكبير',
    text: 'الله أكبر',
    target: 34,
    source: 'صحيح مسلم، حديث 596',
  ),
];

List<DhikrItem> get allAdhkar => [
  ...morningAdhkar,
  ...eveningAdhkar,
  ...sleepAdhkar,
  ...prayerAdhkar,
];

// تخزين محلي على الهاتف باستخدام SharedPreferences.
class AppStore extends ChangeNotifier {
  Set<String> favorites = {};
  Map<String, int> dhikrCounts = {};
  int tasbeehCount = 0;
  int dailyCompleted = 0;
  bool ready = false;

  static const _favoritesKey = 'favorites_v1';
  static const _countsKey = 'dhikr_counts_v1';
  static const _tasbeehKey = 'tasbeeh_count_v1';
  static const _dailyKey = 'daily_completed_v1';
  static const _dateKey = 'daily_date_v1';

  String get todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    favorites = (prefs.getStringList(_favoritesKey) ?? []).toSet();
    tasbeehCount = prefs.getInt(_tasbeehKey) ?? 0;

    final savedDate = prefs.getString(_dateKey);
    if (savedDate == todayKey) {
      dailyCompleted = prefs.getInt(_dailyKey) ?? 0;
      final rawCounts = prefs.getString(_countsKey);
      if (rawCounts != null) {
        try {
          final decoded = jsonDecode(rawCounts) as Map<String, dynamic>;
          dhikrCounts = decoded.map(
            (key, value) => MapEntry(key, (value as num).toInt()),
          );
        } catch (_) {
          dhikrCounts = {};
        }
      }
    } else {
      dailyCompleted = 0;
      dhikrCounts = {};
      await prefs.setString(_dateKey, todayKey);
      await prefs.setInt(_dailyKey, 0);
      await prefs.setString(_countsKey, '{}');
    }

    ready = true;
    notifyListeners();
  }

  bool isFavorite(String id) => favorites.contains(id);
  int countFor(String id) => dhikrCounts[id] ?? 0;

  Future<void> toggleFavorite(String id) async {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, favorites.toList());
    notifyListeners();
  }

  Future<void> incrementDhikr(DhikrItem item) async {
    final current = countFor(item.id);
    if (current >= item.target) return;
    dhikrCounts[item.id] = current + 1;
    dailyCompleted++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_countsKey, jsonEncode(dhikrCounts));
    await prefs.setInt(_dailyKey, dailyCompleted);
    await prefs.setString(_dateKey, todayKey);
    notifyListeners();
  }

  Future<void> resetDhikr(DhikrItem item) async {
    dhikrCounts[item.id] = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_countsKey, jsonEncode(dhikrCounts));
    notifyListeners();
  }

  Future<void> incrementTasbeeh() async {
    tasbeehCount++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tasbeehKey, tasbeehCount);
    notifyListeners();
  }

  Future<void> resetTasbeeh() async {
    tasbeehCount = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tasbeehKey, 0);
    notifyListeners();
  }
}

class RafiqApp extends StatefulWidget {
  const RafiqApp({super.key});

  @override
  State<RafiqApp> createState() => _RafiqAppState();
}

class _RafiqAppState extends State<RafiqApp> {
  final AppStore store = AppStore();

  @override
  void initState() {
    super.initState();
    store.load();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        if (!store.ready) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator(color: brandGreen)),
            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'رفيق الأذكار',
          theme: appTheme,
          home: HomePage(store: store),
        );
      },
    );
  }
}

ThemeData get appTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: brandGreen),
  scaffoldBackgroundColor: pageBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: brandGreen,
    foregroundColor: Colors.white,
    centerTitle: false,
  ),
);

class HomePage extends StatelessWidget {
  final AppStore store;
  const HomePage({super.key, required this.store});

  void open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final sections = [
      _Section('أذكار الصباح', Icons.wb_sunny_outlined, () =>
        open(context, DhikrListScreen(title: 'أذكار الصباح', items: morningAdhkar, store: store))),
      _Section('أذكار المساء', Icons.nights_stay_outlined, () =>
        open(context, DhikrListScreen(title: 'أذكار المساء', items: eveningAdhkar, store: store))),
      _Section('السبحة الإلكترونية', Icons.fingerprint, () =>
        open(context, TasbeehScreen(store: store))),
      _Section('أذكار النوم', Icons.bedtime_outlined, () =>
        open(context, DhikrListScreen(title: 'أذكار النوم', items: sleepAdhkar, store: store))),
      _Section('أذكار بعد الصلاة', Icons.mosque_outlined, () =>
        open(context, DhikrListScreen(title: 'أذكار بعد الصلاة', items: prayerAdhkar, store: store))),
      _Section('المفضلة', Icons.favorite_border, () =>
        open(context, FavoritesScreen(store: store))),
      _Section('إنجازاتي', Icons.bar_chart, () =>
        open(context, ProgressScreen(store: store))),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('رفيق الأذكار', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Text(
                'السلام عليكم ورحمة الله',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Color(0xFF20352F)),
              ),
              const SizedBox(height: 7),
              Text('اجعل لسانك عامراً بذكر الله', style: TextStyle(fontSize: 15, color: Colors.grey.shade700)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [brandGreen, Color(0xFF238875)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.auto_awesome, color: Color(0xFFFFD76A), size: 30),
                    SizedBox(height: 12),
                    Text('ابدأ يومك بذكر الله', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text('أذكار موثقة، وعدادات تساعدك على المتابعة', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Expanded(child: Text('أقسام التطبيق', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                  Text('٧ أقسام', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sections.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.35,
                ),
                itemBuilder: (context, index) {
                  final section = sections[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: section.onTap,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(section.icon, size: 34, color: brandGreen),
                            const SizedBox(height: 10),
                            Text(section.title, textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 5),
                            const Icon(Icons.arrow_back_ios_new, size: 12, color: brandGold),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              AnimatedBuilder(
                animation: store,
                builder: (context, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.today, color: brandGreen, size: 28),
                        const SizedBox(width: 12),
                        const Expanded(child: Text('إنجازات اليوم', style: TextStyle(fontWeight: FontWeight.bold))),
                        Text('${store.dailyCompleted} تكرار', style: const TextStyle(color: brandGreen, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  _Section(this.title, this.icon, this.onTap);
}

class DhikrListScreen extends StatelessWidget {
  final String title;
  final List<DhikrItem> items;
  final AppStore store;

  const DhikrListScreen({
    super.key,
    required this.title,
    required this.items,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) => DhikrCard(item: items[index], store: store),
        ),
      ),
    );
  }
}

class DhikrCard extends StatelessWidget {
  final DhikrItem item;
  final AppStore store;

  const DhikrCard({super.key, required this.item, required this.store});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final count = store.countFor(item.id);
        final completed = count >= item.target;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    IconButton(
                      tooltip: 'إضافة إلى المفضلة',
                      onPressed: () => store.toggleFavorite(item.id),
                      icon: Icon(store.isFavorite(item.id) ? Icons.favorite : Icons.favorite_border,
                        color: store.isFavorite(item.id) ? Colors.red : brandGreen),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(item.text, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 21, height: 1.9, color: Color(0xFF20352F))),
                const SizedBox(height: 12),
                if (item.note.isNotEmpty)
                  Text(item.note, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                const SizedBox(height: 5),
                Text('المصدر: ${item.source}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const Divider(height: 25),
                Row(
                  children: [
                    const Expanded(child: Text('عدد التكرارات', style: TextStyle(fontWeight: FontWeight.w600))),
                    Text('$count / ${item.target}', style: const TextStyle(fontSize: 18, color: brandGreen, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: item.target == 0 ? 0 : (count / item.target).clamp(0.0, 1.0).toDouble(),
                    minHeight: 7,
                    backgroundColor: const Color(0xFFE8EEE9),
                    color: completed ? Colors.green : brandGreen,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: completed ? null : () => store.incrementDhikr(item),
                        icon: Icon(completed ? Icons.check : Icons.add),
                        label: Text(completed ? 'اكتمل الذكر' : 'تسجيل تكرار'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandGreen,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 48),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: 'إعادة العداد',
                      onPressed: count == 0 ? null : () => store.resetDhikr(item),
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TasbeehScreen extends StatelessWidget {
  final AppStore store;
  const TasbeehScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('السبحة الإلكترونية')),
        body: AnimatedBuilder(
          animation: store,
          builder: (context, _) => SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.fingerprint, size: 64, color: brandGreen),
                const SizedBox(height: 18),
                const Text('سبحان الله', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Text('${store.tasbeehCount}',
                  style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: brandGreen)),
                const SizedBox(height: 22),
                SizedBox(
                  width: 190,
                  height: 190,
                  child: ElevatedButton(
                    onPressed: store.incrementTasbeeh,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: brandGreen,
                      foregroundColor: Colors.white,
                      elevation: 5,
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.touch_app, size: 42),
                        SizedBox(height: 8),
                        Text('تسبيح', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                OutlinedButton.icon(
                  onPressed: store.tasbeehCount == 0 ? null : store.resetTasbeeh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة العداد'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final AppStore store;
  const FavoritesScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('المفضلة')),
        body: AnimatedBuilder(
          animation: store,
          builder: (context, _) {
            final items = allAdhkar.where((item) => store.isFavorite(item.id)).toList();
            if (items.isEmpty) {
              return const EmptyState(
                icon: Icons.favorite_border,
                message: 'لم تضف أذكاراً إلى المفضلة بعد',
                detail: 'اضغط على علامة القلب في بطاقة الذكر لإضافته هنا.',
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => DhikrCard(item: items[index], store: store),
            );
          },
        ),
      ),
    );
  }
}

class ProgressScreen extends StatelessWidget {
  final AppStore store;
  const ProgressScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('إنجازاتي')),
        body: AnimatedBuilder(
          animation: store,
          builder: (context, _) {
            final finished = allAdhkar.where((item) => store.countFor(item.id) >= item.target).length;
            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                _StatCard(
                  title: 'تكرارات الأذكار اليوم',
                  value: '${store.dailyCompleted}',
                  icon: Icons.repeat,
                ),
                const SizedBox(height: 12),
                _StatCard(
                  title: 'الأذكار المكتملة',
                  value: '$finished',
                  icon: Icons.task_alt,
                ),
                const SizedBox(height: 12),
                _StatCard(
                  title: 'عدد الأذكار في المفضلة',
                  value: '${store.favorites.length}',
                  icon: Icons.favorite,
                ),
                const SizedBox(height: 18),
                const Text(
                  'يبدأ عداد إنجاز اليوم من جديد تلقائياً عند حلول يوم جديد. تبقى المفضلة محفوظة على الهاتف.',
                  style: TextStyle(color: Colors.grey, height: 1.7),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _StatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(icon, color: brandGreen, size: 30),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
            Text(value, style: const TextStyle(fontSize: 23, color: brandGreen, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String detail;
  const EmptyState({super.key, required this.icon, required this.message, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 58, color: brandGreen),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(detail, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, height: 1.6)),
          ],
        ),
      ),
    );
  }
}