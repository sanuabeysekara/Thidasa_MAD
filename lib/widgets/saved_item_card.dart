import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:news/db/saved_item_database.dart';
import 'package:news/models/saved_item_model.dart';
import 'package:news/views/save_page.dart';

class SavedItemCard extends StatelessWidget {
  final int id;
  final String imgUrl, title, desc, content, postUrl;

  const SavedItemCard(
      {Key? key,
        required this.id,
      required this.imgUrl,
      required this.desc,
      required this.title,
      required this.content,
      required this.postUrl});

  @override
  Widget build(BuildContext context) {
    Future removeSavedItem() async {
      await SavedItemsDatabase.instance.delete(id);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SavePage()),
              (r) => false

      );
    }



    return Card(
      elevation: Sizes.dimen_4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Sizes.dimen_10))),
      margin: const EdgeInsets.fromLTRB(
          Sizes.dimen_8, 0, Sizes.dimen_8, Sizes.dimen_8),
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
                height: 100,
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
                      height: 100,
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
                    value: 'remove',
                    child: Text('Remove'),
                  ),

                ];
              },
              onSelected: (String value){
                print('removed');
                if (value == 'remove') {
                  removeSavedItem();
                  const snackBar = SnackBar(
                    content: Text('News Removed from the Saved News'),
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


}
