import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:introduction_story/introduction_story.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Introduction Story',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Introduction'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text.rich(
                TextSpan(
                  text:
                      'We can suppose that this is a brief for the newly provided feature. Checkout the CTA below.\n',
                  children: [
                    TextSpan(
                      text: 'Tap for more information about $_featureName. 🍇✨😃🎂',
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.lightBlueAccent,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _pushIntroductionStoriesScreen(context),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200]?.withOpacity(.1),
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage('assets/placeholder.png'),
                      ),
                    ),
                  );
                },
                itemCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _featureName => 'Grocery Store';

  void _pushIntroductionStoriesScreen(BuildContext context) {
    Navigator.push<void>(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => IntroductionStoryScreen(
          isDismissible: true,
          isAsset: false,
          stories: [
            Story(
              imagePath: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=464&q=80',
              name: _featureName,
              title: 'Online Grocery Shopping',
              description:
                  'Shop your favourite groceries and ready to cook, heat & '
                  'eat selection of artisanal, handcrafted products made '
                  'fresh daily for you to devour.',
            ),
            Story(
              imagePath: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=464&q=80',
              title: 'Premium quality is our aim',
              name: _featureName,
              
              description:
                  'Categories: Fresh Fruits, Vegetables & Herbs, Bakery & '
                  'Pastry, Cheese, Dairy & Deli, Desserts & Sweets.',
              
            ),
            Story(
              imagePath: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=327&q=80',
              title: 'We deliver fresh and fast',
              name: _featureName,

              description:
                  'Your gourmet groceries are just a click away! Pick your '
                  'favourite groceries and receive your order '
                  'within 15 minutes.',
            ),
          ],
        ),
      ),
    );
  }
}
