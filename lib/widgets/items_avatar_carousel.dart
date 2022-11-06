// import 'dart:html';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:users_food_app/widgets/progress_bar.dart';
import 'package:image_network/image_network.dart';
import 'package:quantity_input/quantity_input.dart';

class ItemsAvatarCarousel extends StatefulWidget {
  const ItemsAvatarCarousel({Key? key}) : super(key: key);

  @override
  State<ItemsAvatarCarousel> createState() => _ItemsAvatarCarouselState();
}

class _ItemsAvatarCarouselState extends State<ItemsAvatarCarousel> {
  int simpleIntInput = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 900,
      width: 600,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("items").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: circularProgress(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.12,
                child: Card(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Image.network(document['thumbnailUrl']),
                      ),
                      Expanded(
                        flex: 5,
                        child: ListTile(
                          title: Text(document['title']),
                          subtitle: Text(document['price']),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          onPressed: () {},
                          color: Colors.amberAccent,
                          icon: Icon(Icons.add_circle, size: 35),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
