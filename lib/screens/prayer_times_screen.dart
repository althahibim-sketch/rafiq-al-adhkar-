import 'package:flutter/material.dart';
import 'package:app_1/core/theme/app_theme.dart';
import 'package:app_1/core/utils/prayer_times.dart';
import 'package:app_1/services/app_store.dart';

class PrayerTimesScreen extends StatefulWidget {
  final AppStore store;
  const PrayerTimesScreen({super.key, required this.store});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late CityLocation _selectedCity;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.store.selectedCity;
  }

  void _chooseCity() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                children: [
                  Icon(Icons.location_on, color: brandGreen),
                  SizedBox(width: 8),
                  Text(
                    'اختر مدينتك لعرض مواقيت الصلاة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: CityLocation.defaultCities.length,
                  itemBuilder: (context, index) {
                    final city = CityLocation.defaultCities[index];
                    final isSelected = city.name == _selectedCity.name;
                    return ListTile(
                      title: Text(
                        '${city.name} (${city.country})',
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? brandGreen : null,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: brandGreen)
                          : null,
                      onTap: () {
                        setState(() => _selectedCity = city);
                        widget.store.setCity(city);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prayers = PrayerTimesCalculator.calculate(
      DateTime.now(),
      _selectedCity,
    );
    final nextPrayerInfo = PrayerTimesCalculator.getNextPrayer(prayers);
    final nextP = nextPrayerInfo['prayer'] as PrayerTime;
    final remaining = nextPrayerInfo['remaining'] as String;

    final iconsMap = {
      'fajr': Icons.wb_twilight,
      'sunrise': Icons.wb_sunny_outlined,
      'dhuhr': Icons.wb_sunny,
      'asr': Icons.cloud_outlined,
      'maghrib': Icons.nights_stay_outlined,
      'isha': Icons.bedtime,
    };

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مواقيت الصلاة'),
          actions: [
            IconButton(
              tooltip: 'تغيير المدينة',
              icon: const Icon(Icons.location_city),
              onPressed: _chooseCity,
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            // بطاقة الصلاة القادمة
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [brandGreen, Color(0xFF238875)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المدينة: ${_selectedCity.name}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                      InkWell(
                        onTap: _chooseCity,
                        child: const Row(
                          children: [
                            Text('تغيير',
                                style: TextStyle(
                                    color: brandGold,
                                    fontWeight: FontWeight.bold)),
                            Icon(Icons.arrow_drop_down, color: brandGold),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'الصلاة القادمة: صلاة ${nextP.arabicName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'متبقي: $remaining',
                    style: const TextStyle(
                      color: Color(0xFFFFD76A),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'مواقيت صلوات اليوم',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // قائمة الصلوات
            ...prayers.map((p) {
              final isNext = p.name == nextP.name;
              return Card(
                elevation: isNext ? 3 : 1,
                color: isNext
                    ? (Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF1B3B32)
                        : const Color(0xFFE5EFE9))
                    : null,
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: Row(
                    children: [
                      Icon(
                        iconsMap[p.name] ?? Icons.access_time,
                        color: isNext ? brandGold : brandGreen,
                        size: 26,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          p.arabicName,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight:
                                isNext ? FontWeight.bold : FontWeight.w600,
                            color: isNext ? brandGreen : null,
                          ),
                        ),
                      ),
                      Text(
                        p.format12Hour(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isNext ? brandGreen : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
