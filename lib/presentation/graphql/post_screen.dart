import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  final Map<String, dynamic> post;
  const PostScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${post['id']}'),
            Text(
              '${post['title']}',
              style: const TextStyle(fontSize: 20),
            ),
            Text('${post['body']}'),
          ],
        ),
      ),
    );
  }
}
