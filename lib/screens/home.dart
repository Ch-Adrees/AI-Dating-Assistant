import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.menu),
      ),
      centerTitle: true,
      title: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.visibility_sharp),
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back_ios_new_outlined))
      ],
    ));
  }
}
