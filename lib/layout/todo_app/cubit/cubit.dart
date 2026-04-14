import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/layout/todo_app/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../../../modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import '../../../modules/todo_app/done_tasks/done_tasks_screen.dart';
import '../../../modules/todo_app/new_tasks/new_tasks_screen.dart';



class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens =
  [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles =
  [
  'New Tasks',
  'DoneTasks',
  'Archived Tasks',
  ];

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeIndex (int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase()  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async
      {
        print('database created');
        await database.execute(
            'CREATE TABLE takes (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then ((value)
        {
          print('table created');
        }).catchError((error){
          print('error when creating table ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);

        print('database opened');

      },
    ).then((value)
    {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

// 1. دالة الإدخال
  Future<void> insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      try {
        int value = await txn.rawInsert(
            'INSERT INTO takes(title, date, time, status) VALUES("$title", "$date", "$time", "new")'
        );
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        // جلب البيانات بعد الإغلاق لضمان التحديث
        await getDataFromDatabase(database);
      } catch (error) {
        print('Error: ${error.toString()}');
      }
    });
  }

// 2. دالة جلب البيانات (مصححة بالكامل)
  Future<void> getDataFromDatabase(database) async
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];


    emit(AppGetDatabaseLoadingState());

    // نستخدم await هنا بدلاً من .then ليكون الكود مستقراً
     database.rawQuery('SELECT * FROM takes').then((value) {

      value.forEach((element){
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else archivedTasks.add(element);
      });

      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({
    required String status,
    required int id,
  }) async
  {
    // نقوم بتنفيذ أمر التحديث
    database.rawUpdate(
      'UPDATE takes SET status = ? WHERE id = ?',
      ['$status', id], // نستخدم العلامات ? لضمان الأمان وتجنب الـ SQL Injection
    ).then((value) {
      // 1. جلب البيانات المحدثة من القاعدة
      getDataFromDatabase(database);
        // 2. إبلاغ الواجهة بأن البيانات تغيرت لتحديث الشاشة
      emit(AppUpdateDatabaseState());
      print('Task $id updated to $status');

    }).catchError((error) {
      print('Error when updating record: ${error.toString()}');
    });
  }

  void deleteData({
    required int id,
  }) async
  {

    database.rawDelete(
      'DELETE FROM takes WHERE id = ?',
      [id], // نستخدم العلامات ? لضمان الأمان وتجنب الـ SQL Injection
    ).then((value) {

      getDataFromDatabase(database);
      emit(AppDeleteDataState());

    }).catchError((error) {
      print('Error when updating record: ${error.toString()}');
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
})
{
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
}

}