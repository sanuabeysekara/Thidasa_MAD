import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/providers/news_provider.dart';

import '../constants/color_constants.dart';
import '../constants/size_constants.dart';
import '../utils/utils.dart';
import '../widgets/dropdown_list.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Filter News';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(appTitle),
        backgroundColor: AppColors.burgundy,
      ),
      body: const FilterScreen(),
    );
  }
}

// Create a Form widget.
class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({super.key});

  @override
  FilterScreenState createState() {
    return FilterScreenState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class FilterScreenState extends ConsumerState<FilterScreen> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        /// For Selecting the Country
        ///
        ///
        ///
        //
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              //Icon(Icons.),
              Expanded(
                  child: Text(
                "Select a Country",
                style: TextStyle(fontSize: 18),
              )),
              Expanded(
                child: DropdownButtonFormField<String>(

                    //validator: (value) => value == null ? "Select a country" : null,

                    value: ref.read(newsProvider).country.isEmpty
                        ? "us"
                        : ref.read(newsProvider).country,
                    onChanged: (String? newValue) {
                      ref.read(newsProvider).country = newValue!;
                      //ref.read(newsProvider).cName = listOfCountry[i]['name']!.toUpperCase();
                      ref.read(newsProvider).getAllNews();
                      ref.read(newsProvider).getBreakingNews();
                    },
                    items: dropdownItems),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              //Icon(Icons.),
              Expanded(
                  child: Text(
                    "Select a Category",
                    style: TextStyle(fontSize: 18),
                  )),
              Expanded(
                child: DropdownButtonFormField<String>(

                  //validator: (value) => value == null ? "Select a country" : null,

                    value: ref.read(newsProvider).category.isEmpty
                        ? "technology"
                        : ref.read(newsProvider).category,
                    onChanged: (String? newValue) {
                      ref.read(newsProvider).category = newValue!;
                      //ref.read(newsProvider).cName = listOfCountry[i]['name']!.toUpperCase();
                      ref.read(newsProvider).getAllNews();
                      ref.read(newsProvider).getBreakingNews();
                    },
                    items: dropdownCategory),
              )
            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(20.0),
        //   child: Row(
        //     children: [
        //       //Icon(Icons.),
        //       Expanded(
        //           child: Text(
        //             "Select a Channel",
        //             style: TextStyle(fontSize: 18),
        //           )),
        //       Expanded(
        //         child: DropdownButtonFormField<String>(
        //
        //           //validator: (value) => value == null ? "Select a country" : null,
        //
        //             value: ref.read(newsProvider).channel.isEmpty
        //                 ? null
        //                 : ref.read(newsProvider).channel,
        //             onChanged: (String? newValue) {
        //               ref.read(newsProvider).country = newValue!;
        //               //ref.read(newsProvider).cName = listOfCountry[i]['name']!.toUpperCase();
        //               ref.read(newsProvider).getAllNews();
        //               ref.read(newsProvider).getBreakingNews();
        //
        //               ref.read(newsProvider).channel = newValue!;
        //               ref.read(newsProvider).getAllNews(channel: newValue);
        //               ref.read(newsProvider).country = '';
        //               ref.read(newsProvider).category = '';
        //               ref.read(newsProvider).notifyListeners();
        //
        //
        //             },
        //             items: dropdownChanel),
        //       )
        //     ],
        //   ),
        // ),


        // ExpansionTile(
        //   collapsedTextColor: AppColors.burgundy,
        //   collapsedIconColor: AppColors.burgundy,
        //   iconColor: AppColors.burgundy,
        //   textColor: AppColors.burgundy,
        //   title: const Text("Select Country"),
        //   children: <Widget>[
        //     for (int i = 0; i < listOfCountry.length; i++)
        //       drawerDropDown(
        //         onCalled: () {
        //           ref.read(newsProvider).country = listOfCountry[i]['code']!;
        //           ref.read(newsProvider).cName =
        //               listOfCountry[i]['name']!.toUpperCase();
        //           ref.read(newsProvider).getAllNews();
        //           ref.read(newsProvider).getBreakingNews();
        //         },
        //         name: listOfCountry[i]['name']!.toUpperCase(),
        //       ),
        //   ],
        // ),

        /// For Selecting the Category

        const Divider(),






        Padding(
          padding: const EdgeInsets.all(80.0),
          child: ElevatedButton(
            onPressed: () async {

              const snackBar = SnackBar(
                content: Text('Filter Added'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).pop();
            },
            child: Text('Add Filter'),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
          ),
        ),

      ],
    );
  }
}
