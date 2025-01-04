import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? automaticallyImplyLeading;
  final List<Widget>? actions;
  const AppbarWidget(
    this.title, 
    {
      super.key, 
      this.automaticallyImplyLeading,
      this.actions
    }
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: automaticallyImplyLeading ?? false,
      actions: actions,
      leading: automaticallyImplyLeading != null 
      ? IconButton(
          onPressed: (){

          }, 
          icon: Icon(Icons.arrow_back)
        )
      : null,
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}