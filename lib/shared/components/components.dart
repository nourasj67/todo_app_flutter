import 'package:flutter/material.dart';

import '../../layout/todo_app/cubit/cubit.dart';

Widget defaultButton ({
  double width = double.infinity,
  Color background = Colors.deepPurple,
  bool isUpperCase = true,
  double radius = 0.0,
  required Function() function,
  required String text,
}) =>
      Container(
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: background,
        ),
      child:
        MaterialButton(
          onPressed: function,
          child:
          Text(
            style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            ),
            isUpperCase ? text.toUpperCase() : text,
          ),
        ),
      );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required IconData prefix,
  required String? Function(String?) validate,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? onTap,
  bool isPassword = false,
  IconData? suffix,
  VoidCallback? suffixPressed,

}) =>
      TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        onFieldSubmitted: onSubmit,
        onTap: onTap,
        validator: validate,
        decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null ? IconButton(
          icon:
          Icon(
              suffix,
            ),
          onPressed: suffixPressed,
        ) : null,
        border: OutlineInputBorder(),
        ),
      );

Widget buildTasksItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id'],);
  },
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40,
          child: Text(
            '${model['time']}',
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${model['date']}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        IconButton(
            onPressed: (){
              AppCubit.get(context).updateDatabase(status: 'done', id: model['id'],);
            },
            icon: Icon(
              Icons.check_box,
              color: Colors.lightGreen,
            ),
        ),
        IconButton(
          onPressed: (){
            AppCubit.get(context).updateDatabase(status: 'archive', id: model['id'],);
          },
          icon: Icon(
            Icons.archive,
            color: Colors.grey,
          ),
        ),
  
      ],
  
  
    ),
  ),
);

Widget MyDivider() => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Container(
    height: 1,
    color: Colors.grey,
  ),
);
