import 'dart:math';
import 'package:flutter/material.dart';
import 'package:app_1/core/theme/app_theme.dart';
import 'package:app_1/core/utils/prayer_times.dart';
import 'package:app_1/services/app_store.dart';

class QiblaScreen extends StatefulWidget {
  final AppStore store;
  const QiblaScreen({super.key, required this.store});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
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
                    'اختر مدينتك لتحديد القبلة ومواقيت الصلاة',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
    final qiblaAngle = PrayerTimesCalculator.calculateQiblaDirection(
      _selectedCity.latitude,
      _selectedCity.longitude,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('بوصلة اتجاه القبلة'),
          actions: [
            IconButton(
              tooltip: 'تغيير المدينة',
              icon: const Icon(Icons.location_city),
              onPressed: _chooseCity,
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // بطاقة المدينة المحددة
                Card(
                  child: InkWell(
                    onTap: _chooseCity,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: brandGreen),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'المدينة الحالية: ${_selectedCity.name} (${_selectedCity.country})',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Icon(Icons.swap_horiz, color: brandGold),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // عرض درجة القبلة
                Text(
                  '${qiblaAngle.round()}°',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: brandGreen,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'زاوية القبلة من الشمال الجغرافي',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 35),

                // البوصلة ومؤشر الكعبة
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // حلقة البوصلة الخارجية
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: brandGreen, width: 4),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF14241F)
                            : const Color(0xFFEAF2EE),
                      ),
                      child: const Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('ش (0°)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('ج (180°)',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('ق (90°)',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('غ (270°)',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // إبرة مؤشر اتجاه الكعبة
                    Transform.rotate(
                      angle: qiblaAngle * pi / 180,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: brandGold,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.mosque,
                                color: Colors.white, size: 28),
                          ),
                          Container(
                            width: 4,
                            height: 75,
                            color: brandGold,
                          ),
                          const SizedBox(height: 85),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),

                // بطاقة إرشادية
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: brandGreen),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'ضع الهاتف أفقياً على سطح مستوٍ، واجعل رأس الهاتف متجهاً بزاوية ${qiblaAngle.round()}° لتستقبل الكعبة المشرفة بمكة المكرمة بدقة.',
                            style: const TextStyle(fontSize: 13, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
