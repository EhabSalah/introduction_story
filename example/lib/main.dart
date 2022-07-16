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
      theme: ThemeData.light(),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Press to introduce new thing to user 👀',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    // fullscreenDialog: true,
                    opaque: false,
                    pageBuilder: (_, __, ___) => StoryIntroductionScreen(
                      StoryIntroductionProps(
                        featureName: '',
                        duration: 4000,
                        stories: [
                          Story(
                            title: 'React',
                            backgroundColor: Colors.red,
                            description: 'Description',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: const Text('New feature ✨'),
            ),
          ],
        ),
      ),
    );
  }
}
