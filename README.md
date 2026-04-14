# News App - Flutter 📰

A modern, fast, and responsive news application built with **Flutter**. This app fetches real-time global news from the **NewsAPI**, allowing users to stay updated with the latest headlines across various categories like Business, Science, Sports, and more.

## ✨ Features
* **Real-time Data:** Fetches latest articles using NewsAPI.
* **Search Functionality:** Advanced search to find specific topics.
* **Category Filtering:** Browse news by categories (Business, Science, Sports).
* **In-App WebView:** Read full articles without leaving the app.
* **Theme Support:** Full support for Light and Dark modes.
* **State Management:** Built using the **Bloc/Cubit** pattern for a clean and scalable architecture.

## 🛠️ Built With
* **[Flutter](https://flutter.dev/):** UI Framework.
* **[Bloc & Cubit](https://pub.dev/packages/flutter_bloc):** State management.
* **[Dio](https://pub.dev/packages/dio):** Powerful HTTP client for API calls.
* **[WebView Flutter](https://pub.dev/packages/webview_flutter):** For displaying web content.
* **[Conditional Builder](https://pub.dev/packages/conditional_builder_null_safety):** To handle loading and empty states gracefully.
* **[HexColor](https://pub.dev/packages/hexcolor):** For easy custom color management.

---

## 📝 وصف التطبيق 

تطبيق إخباري عصري مبني باستخدام إطار عمل **Flutter**، يتيح للمستخدمين متابعة آخر الأخبار العالمية والمحلية لحظة بلحظة. يتميز التطبيق بواجهة مستخدم سلسة تدعم التنقل بين تصنيفات مختلفة (أعمال، علوم، رياضة)، بالإضافة إلى خاصية البحث المتقدم، ودعم كامل للوضع الليلي (Dark Mode). كما يوفر تجربة قراءة متكاملة للمقالات عبر متصفح داخلي (WebView).

### 🚀 المميزات الرئيسية:
* **بيانات فورية:** جلب المقالات من NewsAPI.
* **إدارة الحالة:** استخدام نمط **Bloc/Cubit** لضمان كود نظيف وقابل للتطوير.
* **البحث:** إمكانية البحث عن أي موضوع إخباري.
* **متصفح داخلي:** قراءة الخبر كاملاً داخل التطبيق.

---

### 💡 How to run | كيف تشغل المشروع
1. Clone the repository.
2. Run `flutter pub get`.
3. Ensure you have your **NewsAPI Key** set up in the `DioHelper` or relevant logic file.
4. Run the app on your emulator or physical device.