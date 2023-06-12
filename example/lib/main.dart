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
                      text: 'Tap for more information about $_featureName. 🍇',
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
          stories: [
            Story(
              imagePath: 'https://upload.wikimedia.org/wikipedia/commons/4/44/Jelly_cc11.jpg',
              name: _featureName,
              title: 'Online Grocery Shopping',
              description:
                  'Shop your favourite groceries and ready to cook, heat & '
                  'eat selection of artisanal, handcrafted products made '
                  'fresh daily for you to devour.',
            ),
            Story(
              imagePath: 'https://upload.wikimedia.org/wikipedia/commons/4/44/Jelly_cc11.jpg',
              title: 'Premium quality is our aim',
              name: _featureName,
              description:
                  'Categories: Fresh Fruits, Vegetables & Herbs, Bakery & '
                  'Pastry, Cheese, Dairy & Deli, Desserts & Sweets.',
              decoration: const StoryDecoration(lightMode: false),
            ),
            Story(
              imagePath: 'https://images.squarespace-cdn.com/content/v1/54fc8146e4b02a22841f4df7/adae5b77-380f-4c37-ae1a-97323e66ed55/Art_of_1.jpg',
              title: 'We deliver fresh and fast',
              name: _featureName,
              description:
                  'Your gourmet groceries are just a click away! Pick your '
                  'favourite groceries and receive your order '
                  'within 15 minutes.',
              decoration: const StoryDecoration(lightMode: false),
            ),
          ],
        ),
      ),
    );
  }
}
