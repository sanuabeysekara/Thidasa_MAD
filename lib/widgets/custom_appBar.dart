import 'package:news/constants/color_constants.dart';
import 'package:news/constants/size_constants.dart';
import 'package:flutter/material.dart';

customAppBar(String title, BuildContext context,
    {bool? automaticallyImplyLeading, Widget? leading, List<Widget>? actions}) {
  TextTheme textTheme = Theme.of(context).textTheme;
  return AppBar(
    iconTheme: const IconThemeData(color: AppColors.thidasaLightBlue),
    automaticallyImplyLeading: automaticallyImplyLeading ?? true,
    leading: leading,
    backgroundColor: AppColors.thidasaBlue,
    elevation: 3.0,
    centerTitle: false,
    toolbarHeight: Sizes.dimen_64,
    actions: actions,
    title: Column(
      children: [

        Image.asset('assets/images/logo.png', fit: BoxFit.fitHeight, height: 50,)
      ],
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(Sizes.dimen_10),
        bottomRight: Radius.circular(Sizes.dimen_10),
      ),
    ),
  );
}
