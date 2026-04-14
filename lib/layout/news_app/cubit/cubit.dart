import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/layout/news_app/cubit/states.dart';
import 'package:my_app/modules/business/business_screen.dart';
import 'package:my_app/modules/science/science_screen.dart';
import 'package:my_app/modules/settings_screen/settings_screen.dart';
import 'package:my_app/modules/sports/sport_screen.dart';
import 'package:my_app/shared/network/local/cache_helper.dart';

import '../../../shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.business,
      ),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports_baseball_outlined,
      ),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.science_outlined,
      ),
      label: 'Science',
    ),

  ];

  List<Widget> screens = [
    BusinessScreen(),
    SportScreen(),
    ScienceScreen(),

  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;

    //  && science.isEmpty تحميل البيانات فقط عند الحاجة (Lazy Loading) && sports.isEmpty
    if (index == 1) {
      getSports();
    } else if (index == 2) {
      getScience();
    }

    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];

  void getBusiness() {
    emit(NewsGetBusinessLoadingState());

    DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'us',
          // كود الدولة (eg لمصر، sa للسعودية، ae للإمارات)
          'category': 'business',
          // القسم (business, sports, science, health, technology)
          'apiKey': '06e5e16530f04fd28089060d61457bfa',
          // ضع المفتاح الذي حصلت عليه هنا
        }
    ).then((value) {
// هنا استلمنا الرد بنجاح (Response)
      business = value.data['articles'];
      print(business[0]['title']);



      emit(NewsGetBusinessSuccessState());
    }).catchError((error) {
      print('Error during fetching news: ${error.toString()}');
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }

  List<dynamic> sports = [];

  void getSports() {
    emit(NewsGetSportsLoadingState());

    DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'us',
          // كود الدولة (eg لمصر، sa للسعودية، ae للإمارات)
          'category': 'sports',
          // القسم (business, sports, science, health, technology)
          'apiKey': '06e5e16530f04fd28089060d61457bfa',
          // ضع المفتاح الذي حصلت عليه هنا
        }
    ).then((value) {
// هنا استلمنا الرد بنجاح (Response)
      sports = value.data['articles'];
      print(sports[0]['title']);

      emit(NewsGetSportsSuccessState());
    }).catchError((error) {
      print('Error during fetching news: ${error.toString()}');
      emit(NewsGetSportsErrorState(error.toString()));
    });
  }


  List<dynamic> science = [];

  void getScience() {
    emit(NewsGetScienceLoadingState());

    DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'us',
          // كود الدولة (eg لمصر، sa للسعودية، ae للإمارات)
          'category': 'science',
          // القسم (business, sports, science, health, technology)
          'apiKey': '06e5e16530f04fd28089060d61457bfa',
          // ضع المفتاح الذي حصلت عليه هنا
        }
    ).then((value) {
// هنا استلمنا الرد بنجاح (Response)
      science = value.data['articles'];
      print(science[0]['title']);

      emit(NewsGetScienceSuccessState());
    }).catchError((error) {
      print('Error during fetching news: ${error.toString()}');
      emit(NewsGetScienceErrorState(error.toString()));
    });
  }

  List<dynamic> search = [];

  void getSearch(String value) {
    search = [];
    emit(NewsGetSearchLoadingState());


    DioHelper.getData(
        url: 'v2/everything',
        query: {
          'q': value,
          'apiKey': '06e5e16530f04fd28089060d61457bfa',
          // ضع المفتاح الذي حصلت عليه هنا
        }
    ).then((response) {
// 2. التحقق من أن البيانات ليست Null قبل الإسناد
      search = response.data['articles'];

      // 3. طباعة آمنة: لا تطبع العنصر 0 إلا إذا كانت القائمة تحتوي بيانات
      if (search.isNotEmpty) {
        print('First Result: ${search[0]['title']}');
      } else {
        print('No results found for: $value');
      }
      emit(NewsGetSearchSuccessState());
    }).catchError((error) {
      print('Error during fetching news: ${error.toString()}');
      emit(NewsGetSearchErrorState(error.toString()));
    });
  }

  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    if(fromShared != null)
      {
        isDark = fromShared;
        emit(AppChangeModeState());
      }
    else {
      isDark = !isDark;
      getBusiness();
      CacheHelper.putBool(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }

}