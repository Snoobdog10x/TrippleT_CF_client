import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users_food_app/assistantMethods/assistant_methods.dart';
import 'package:users_food_app/widgets/items_avatar_carousel.dart';
import 'package:users_food_app/widgets/my_drawer.dart';
import 'package:users_food_app/widgets/progress_bar.dart';
import 'package:users_food_app/widgets/design/bottom_cart_bar.dart';

import '../authentication/login.dart';
import '../widgets/seller_avatar_carousel.dart';
import '../widgets/user_info.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    clearCartNow(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Menu"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                ),
                child: const Icon(Icons.exit_to_app),
              ),
              onTap: () {
                firebaseAuth.signOut().then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => const LoginScreen(),
                    ),
                  );
                  _controller.clear();
                });
              },
            ),
          ),
        ],
      ),
      body: ItemsAvatarCarousel(),
    );
  }
}
