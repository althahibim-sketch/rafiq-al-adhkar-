import 'package:app_1/models/dhikr_item.dart';

// النصوص المختارة مرتبطة بمراجع محددة. يمكن إضافة أذكار أخرى
// لاحقاً بعد مراجعة النص والعدد والمصدر.
const List<DhikrItem> morningAdhkar = [
  DhikrItem(
    id: 'morning_sayyid',
    title: 'سيد الاستغفار',
    text:
        'اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك، وأنا على عهدك ووعدك ما استطعت، أعوذ بك من شر ما صنعت، أبوء لك بنعمتك علي، وأبوء بذنبي، فاغفر لي، فإنه لا يغفر الذنوب إلا أنت.',
    target: 1,
    source: 'صحيح البخاري، حديث 6306',
    note: 'يقال مرة واحدة في الصباح.',
  ),
  DhikrItem(
    id: 'morning_protection',
    title: 'ذكر الحفظ',
    text:
        'بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم.',
    target: 3,
    source: 'سنن أبي داود 5088، وجامع الترمذي 3388',
    note: 'يقال ثلاث مرات صباحاً.',
  ),
];

const List<DhikrItem> eveningAdhkar = [
  DhikrItem(
    id: 'evening_sayyid',
    title: 'سيد الاستغفار',
    text:
        'اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك، وأنا على عهدك ووعدك ما استطعت، أعوذ بك من شر ما صنعت، أبوء لك بنعمتك علي، وأبوء بذنبي، فاغفر لي، فإنه لا يغفر الذنوب إلا أنت.',
    target: 1,
    source: 'صحيح البخاري، حديث 6306',
    note: 'يقال مرة واحدة في المساء.',
  ),
  DhikrItem(
    id: 'evening_protection',
    title: 'ذكر الحفظ',
    text:
        'بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم.',
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
