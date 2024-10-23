// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:things_to_study/data/graphQL/graphql_datasource.dart';
import 'package:things_to_study/presentation/graphql/post_screen.dart';

class GraphQLExample extends StatefulWidget {
  const GraphQLExample({super.key});

  @override
  State<GraphQLExample> createState() => _GraphQLExampleState();
}

class _GraphQLExampleState extends State<GraphQLExample> {
  final graphQL = GraphQLDatasource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GraphQL Post List Example')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final post = await graphQL.createOnePost();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Post criado: ${post['title']}'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: graphQL.getAllPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final idPost = int.parse(post['id']);
              return GestureDetector(
                onTap: () async {
                  final postResponseForExample =
                      await graphQL.getPostById(idPost);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostScreen(
                        post: postResponseForExample,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'ID: ${post['id']}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () async {
                                      final id = int.parse(post['id']);
                                      final hasUpdated =
                                          await graphQL.updatePost(id);

                                      if (hasUpdated != null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Post atualizado com sucesso!'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: () async {
                                      final id = int.parse(post['id']);
                                      final hasDeleted =
                                          await graphQL.deletePost(id);

                                      if (hasDeleted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Post deletado com sucesso!'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Title: ${post['title']}',
                                style: const TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
