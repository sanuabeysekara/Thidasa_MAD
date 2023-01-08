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
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),
    backgroundColor: AppColors.thidasaBlue,
    elevation: 3.0,
    centerTitle: true,
    toolbarHeight: Sizes.dimen_64,
    title: Column(
      children: [

        Image.asset('assets/images/logo_horizontal.png', fit: BoxFit.fitHeight, height: 100,)
      ],
    ),
  );
}
