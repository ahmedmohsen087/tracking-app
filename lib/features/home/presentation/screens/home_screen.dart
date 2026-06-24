import 'package:flutter/material.dart';
import '../../../../core/values/assets.dart';
import '../widgets/flower_order_item.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset(Assets.appBarIcon,),
          )
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children:[
          FlowerOrderItem(),

          ],
        ),
      ),
    );
  }
}
