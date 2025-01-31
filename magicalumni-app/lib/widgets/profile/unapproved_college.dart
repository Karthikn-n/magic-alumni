import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/model/colleges_model.dart';

class UnapprovedCollege extends StatelessWidget {
  final CollegesModel college;
  const UnapprovedCollege({super.key, required this.college});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:  SizedBox(
        height: 20,
        width: 20,
        child: Image.asset(
          "assets/icon/college.png", color: Theme.of(context).primaryColor,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        college.collegeName,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500
        ),
      ),
      subtitle: Text(
        college.departments[0].departmentName
      ),
      trailing: college.status =="Pending"
      ? Icon(CupertinoIcons.info_circle, color: Colors.red,)
      : Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.green,),
    );
  }
}