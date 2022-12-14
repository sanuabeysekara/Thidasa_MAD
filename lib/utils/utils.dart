import 'package:flutter/material.dart';

// var listOfCountry = [
//   {"name": "INDIA", "code": "in"},
//   {"name": "USA", "code": "us"},
//   {"name": "UK", "code": "gb"},
//   {"name": "MEXICO", "code": "mx"},
//   {"name": "United Arab Emirates", "code": "ae"},
//   {"name": "New Zealand", "code": "nz"},
//   {"name": "Australia", "code": "au"},
//   {"name": "Canada", "code": "ca"},
// ];

List<DropdownMenuItem<String>> get dropdownItems{
  List<DropdownMenuItem<String>> listOfCountry = [
    DropdownMenuItem(child: Text("INDIA"),value: "in"),
    DropdownMenuItem(child: Text("USA"),value: "us"),
    DropdownMenuItem(child: Text("UK"),value: "gb"),
    DropdownMenuItem(child: Text("MEXICO"),value: "mx"),
    DropdownMenuItem(child: Text("U.A.E"),value: "ae"),
    DropdownMenuItem(child: Text("New Zealand"),value: "nz"),
    DropdownMenuItem(child: Text("Australia"),value: "au"),
    DropdownMenuItem(child: Text("Canada"),value: "ca"),
  ];
  return listOfCountry;
}

List<DropdownMenuItem<String>> get dropdownCategory{
  List<DropdownMenuItem<String>> listOfCategory = [
    DropdownMenuItem(child: Text("Science"),value: "science"),
    DropdownMenuItem(child: Text("Business"),value: "business"),
    DropdownMenuItem(child: Text("Technology"),value: "technology"),
    DropdownMenuItem(child: Text("Sports"),value: "sports"),
    DropdownMenuItem(child: Text("Health"),value: "health"),
    DropdownMenuItem(child: Text("General"),value: "general"),
    DropdownMenuItem(child: Text("Entertainment"),value: "entertainment"),
  ];
  return listOfCategory;
}

// var listOfCategory = [
//   {"name": "Science", "code": "science"},
//   {"name": "Business", "code": "business"},
//   {"name": "Technology", "code": "technology"},
//   {"name": "Sports", "code": "sports"},
//   {"name": "Health", "code": "health"},
//   {"name": "General", "code": "general"},
//   {"name": "Entertainment", "code": "entertainment"},
//   {"name": "ALL", "code": null},
// ];

List<DropdownMenuItem<String>> get dropdownChanel{
  List<DropdownMenuItem<String>> listOfNewsChannel = [
    DropdownMenuItem(child: Text("BBC News"),value: "bbc-news"),
    DropdownMenuItem(child: Text("ABC News"),value: "abc-news"),
    DropdownMenuItem(child: Text("The Times of India"),value: "the-times-of-india"),
    DropdownMenuItem(child: Text("ESPN Cricket"),value: "espn-cric-info"),
    DropdownMenuItem(child: Text("politico"),value: "Politico"),
    DropdownMenuItem(child: Text("The Washington Post"),value: "the-washington-post"),
    DropdownMenuItem(child: Text("CNN"),value: "cnn"),
    DropdownMenuItem(child: Text("Reuters"),value: "reuters"),
    DropdownMenuItem(child: Text("NBC news"),value: "nbc-news"),
    DropdownMenuItem(child: Text("The Hill"),value: "the-hill"),
    DropdownMenuItem(child: Text("Fox News"),value: "fox-news"),


  ];
  return listOfNewsChannel;
}


// var listOfNewsChannel = [
//   {"name": "BBC News", "code": "bbc-news"},
//   {"name": "ABC News", "code": "abc-news"},
//   {"name": "The Times of India", "code": "the-times-of-india"},
//   {"name": "ESPN Cricket", "code": "espn-cric-info"},
//   {"code": "politico", "name": "Politico"},
//   {"code": "the-washington-post", "name": "The Washington Post"},
//   {"code": "reuters", "name": "Reuters"},
//   {"code": "cnn", "name": "cnn"},
//   {"code": "nbc-news", "name": "NBC news"},
//   {"code": "the-hill", "name": "The Hill"},
//   {"code": "fox-news", "name": "Fox News"},
// ];
