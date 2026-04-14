import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:my_app/shared/components/components.dart';
import 'package:sqflite/sqflite.dart';
import '../../shared/components/constants.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';


class HomeLayout extends StatelessWidget {
  @override




  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();




  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {
            if(state is AppInsertDatabaseState)
              {
                // بمجرد نجاح الإدخال، قم بتنظيف الحقول
                titleController.clear();
                timeController.clear();
                dateController.clear();

                Navigator.pop(context);
              }
          },
        builder: (BuildContext context, AppStates state)
        {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Center(
                  child: Text(
                    cubit.titles[cubit.currentIndex],
                  ),
                ),
                elevation: 20,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),

              ),
              body: state is AppGetDatabaseLoadingState ? Center(child: CircularProgressIndicator()) : cubit.screens[cubit.currentIndex],
              floatingActionButton: FloatingActionButton(
                onPressed: () {

                  if(cubit.isBottomSheetShown){
                    if(formKey.currentState!.validate())
                    {
                      cubit.insertToDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text,
                      );
                    }

                  } else
                  {
                    scaffoldKey.currentState?.showBottomSheet(
                          (context) => Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              defaultFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                label: 'Task Title',
                                prefix: Icons.title,
                                validate: (String? value)
                                {
                                  if(value == null || value.isEmpty)
                                  {
                                    return 'title must not be empty';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              defaultFormField(
                                controller: timeController,
                                type: TextInputType.datetime,
                                label: 'Task Time',
                                prefix: Icons.watch_later_outlined,
                                onTap: (){
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value)
                                  {
                                    timeController.text = value!.format(context).toString();
                                  });
                                },
                                validate: (String? value)
                                {
                                  if(value == null || value.isEmpty)
                                  {
                                    return 'time must not be empty';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),

                              defaultFormField(
                                controller: dateController,
                                type: TextInputType.datetime,
                                label: 'Task Date',
                                prefix: Icons.calendar_today,
                                onTap: (){
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2026-03-25'),
                                  ).then((value) {
                                    dateController.text = DateFormat.yMMMd().format(value!);
                                  });
                                },
                                validate: (String? value)
                                {
                                  if(value == null || value.isEmpty)
                                  {
                                    return 'time must not be empty';
                                  }
                                  return null;
                                },
                              ),

                            ],
                          ),
                        ),
                      ),
                          elevation: 20,
                    ).closed.then((value)
                    {
                      cubit.changeBottomSheetState
                        (
                          isShow: false,
                          icon: Icons.edit,
                        );
                    });

                    cubit.changeBottomSheetState
                      (
                        isShow: true,
                        icon: Icons.add,
                    );
                  }

                },
                child: Icon(
                  cubit.fabIcon,
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: cubit.currentIndex,
                  onTap: (index){
                    cubit.changeIndex(index);
                  },
                  items:
                  [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.task,
                      ),
                      label: 'Tasks',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.check_circle_outline,
                      ),
                      label: 'Done',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.archive_outlined,
                      ),
                      label: 'Archived',
                    ),
                  ]
              ),

            );
        },

      ),
    );

  }



}




