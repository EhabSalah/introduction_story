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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Press to introduce new thing to user 👀',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (_, __, ___) => StoryIntroductionScreen(
                        StoryIntroductionProps(
                          featureName: 'New Feature Name',
                          duration: 4000,
                          isDismissible: true,
                          stories: [
                            Story(
                              title: 'React',
                              backgroundColor: Colors.red,
                              description: 'Description',
                            ),
                            Story(
                              title: 'React',
                              backgroundColor: Colors.green,
                              description: 'Description',
                            ),
                            Story(
                              title: 'React',
                              backgroundColor: Colors.blue,
                              description: 'Description',
                            ),
                            Story(
                              title: 'React',
                              backgroundColor: Colors.orange,
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
      ),
    );
  }
}
