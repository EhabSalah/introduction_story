import 'package:flutter/material.dart';
import 'package:story_introduction/story_introduction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story Introduction',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Introduction'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Press to introduce new feature to user 👀',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _pushIntroductionStoriesScreen(context),
                child: const Text('New feature ✨'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pushIntroductionStoriesScreen(BuildContext context) {
    Navigator.push<void>(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => StoryIntroduction(
          duration: 10000,
          isDismissible: true,
          stories: [
            Story(
              imagePath: 'assets/IMAGE-1.png',
              foreground: const _StoryForeground(
                foregroundColor: Colors.white,
                title: 'Online Grocery Shopping',
                description:
                    'Shop your favourite groceries and ready to cook, heat & eat selection of artisanal, handcrafted products made fresh daily for you to devour.',
              ),
            ),
            Story(
              imagePath: 'assets/IMAGE-2.png',
              lightMode: false,
              foreground: const _StoryForeground(
                foregroundColor: Colors.black,
                title: 'Premium quality is our aim',
                description:
                    'Categories: Fresh Fruits, Vegetables & Herbs, Bakery & Pastry, Cheese, Dairy & Deli, Desserts & Sweets.',
              ),
            ),
            Story(
              imagePath: 'assets/IMAGE-3.png',
              lightMode: false,
              foreground: const _StoryForeground(
                foregroundColor: Colors.black,
                title: 'We deliver fresh and fast',
                description:
                    'Your Gourmet groceries are just a click away! Pick your favourite groceries and receive your order within 15 minutes.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryForeground extends StatelessWidget {
  final String title;
  final String description;
  final Color foregroundColor;

  const _StoryForeground({
    Key? key,
    required this.title,
    required this.description,
    required this.foregroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Feature name and Skip button
          _FeatureNameAndSkip(
            'Grocery Store',
            color: foregroundColor,
          ),

          const SizedBox(height: 2),

          // Story Title
          Text(
            title,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Story Description
          Text(
            description,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureNameAndSkip extends StatelessWidget {
  final String name;
  final Color color;

  const _FeatureNameAndSkip(this.name, {Key? key, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsetsDirectional.only(start: 16, bottom: 8),
            child: Icon(Icons.clear, color: color, size: 20),
          ),
        ),
      ],
    );
  }
}
