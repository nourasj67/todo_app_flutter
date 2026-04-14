import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:my_app/shared/bloc_observer.dart';
import 'package:my_app/shared/cubit/cubit.dart';
import 'package:my_app/shared/network/local/cache_helper.dart';
import 'package:my_app/shared/network/remote/dio_helper.dart';

import 'layout/news_app/cubit/cubit.dart';
import 'layout/news_app/cubit/states.dart';
import 'layout/news_app/news_layout.dart';


void main() async
{
  //السطر القادم يتأكد أن كل شيء انتهى قبل فتح التطبيق
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool? isDark = CacheHelper.getBool(key: 'isDark');

  runApp(MyApp(isDark!));
}

class MyApp extends StatelessWidget
{

  final bool isDark;
  MyApp(this.isDark);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context) => NewsCubit()..changeAppMode(fromShared: isDark,)..getBusiness(),
      child: BlocConsumer<NewsCubit, NewsStates>(
          listener: (context, state) {},
          builder: (context, state) {


            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true, // تفعيل النسخة الأحدث من ماتيريال
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.orange, // سيقوم النظام بتوليد درجات البرتقالي المتناسقة
                  primary: Colors.orange,   // اللون الأساسي للعناصر النشطة
                ),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.orange, // لون الخلفية
                  foregroundColor: Colors.white,
                ),
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: AppBarTheme(
                  titleSpacing: 20,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.dark,
                  ),
                  backgroundColor: Colors.grey[200],
                  elevation: 0,
                  titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.orange,
                  unselectedItemColor: Colors.grey,
                  elevation: 20,
                  backgroundColor: Colors.grey[200],
                ),
                /*textTheme: TextTheme(
                  headlineMedium: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),*/
                textTheme: TextTheme(
                  headlineMedium: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),


              darkTheme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark, // للثيم العام
                scaffoldBackgroundColor: HexColor('#0B1118'),

                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.orange,
                  brightness: Brightness.dark, // ضروري جداً لكي تكون الألوان المولدة داكنة
                  primary: Colors.orange,
                  surface: HexColor('#151D27'), // لون الكروت والعناصر العلوية
                ),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.orange, // لون الخلفية
                  foregroundColor: Colors.white,
                ),
                appBarTheme: AppBarTheme(
                  titleSpacing: 20,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.light,
                  ),
                  backgroundColor: HexColor('#151D27'),
                  elevation: 0,
                  titleTextStyle: TextStyle(
                    color: Colors.deepOrange[400],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.deepOrange[400],
                  ),
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.deepOrange[400],
                  unselectedItemColor: Colors.grey,
                  elevation: 20,
                  backgroundColor: HexColor('#151D27'),
                ),
                textTheme: TextTheme(
                  headlineMedium:
                  TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),


              themeMode: NewsCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
              home: NewsLayout(),
            );
          },
      ),

    );

  }
}

