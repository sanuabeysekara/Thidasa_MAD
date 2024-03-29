import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:news/models/saved_item_model.dart';

class NewsCard extends StatelessWidget {
  final String imgUrl, title, desc, content, postUrl;

  const NewsCard(
      {Key? key,
      required this.imgUrl,
      required this.desc,
      required this.title,
      required this.content,
      required this.postUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Sizes.dimen_4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Sizes.dimen_10))),
      margin: const EdgeInsets.fromLTRB(
          Sizes.dimen_16, 0, Sizes.dimen_16, Sizes.dimen_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(Sizes.dimen_10),
                  topRight: Radius.circular(Sizes.dimen_10)),
              child: Image.network(
                imgUrl,
                height: 200,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
                // if the image is null
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: const SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Icon(Icons.broken_image_outlined),
                    ),
                  );
                },
              )),
          vertical15,
          Padding(
            padding: const EdgeInsets.all(Sizes.dimen_6),
            child: Text(
              title,
              maxLines: 2,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Sizes.dimen_6),
            child: Text(
              desc,
              maxLines: 2,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child:           PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'add',
                    child: Text('Add'),
                  ),

                ];
              },
              onSelected: (String value){
                print('added');
                if (value == 'add') {
                  addSavedItem();
                  const snackBar = SnackBar(
                    content: Text('News Added to the Saved News'),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  // You can navigate the user to edit page.
                }
              },
            ),

          )

        ],
      ),
    );
  }

  Future addSavedItem() async {
    final savedItem = SavedItem(
      author: "BBC",
      title: title,
      urlToImage: imgUrl,
      url: postUrl,
      content: content,
      description: desc,
      publishedAt: "NEWZ"
    );

  }
}
