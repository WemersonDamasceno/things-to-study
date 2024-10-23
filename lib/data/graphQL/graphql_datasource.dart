import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class GraphQLDatasource {
  final String endpoint = 'https://graphqlzero.almansi.me/api';
  Future<List<dynamic>> getAllPosts() async {
    const queryGetAllPosts = """
      query {
        posts {
          data {
            id
            title
          }
        }
      }
    """;

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': queryGetAllPosts}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data']['posts']['data'];
    } else {
      throw Exception('Erro ao carregar post');
    }
  }

  Future<Map<String, dynamic>?> updatePost(int idPost) async {
    const muttationUpdatePost = """
      mutation {
        updatePost(id: 1, input: { title: "Novo Título", body: "Novo conteúdo do post" }) {
          id
          title
          body
        }
      }
    """;

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': muttationUpdatePost}),
    );

    if (response.statusCode == 200) {
      log(response.body);
      return jsonDecode(response.body)['data']['updatePost'];
    } else {
      throw Exception('Erro ao atualizar post');
    }
  }

  Future<Map<String, dynamic>> createOnePost() async {
    const mutationCreatePost = """
      mutation {
        createPost(input: { title: "Meu Primeiro Post", body: "Este é o conteúdo do post" }) {
          id
          title
          body
        }
      }
    """;

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': mutationCreatePost}),
    );

    if (response.statusCode == 200) {
      log(response.body);
      return jsonDecode(response.body)['data']['createPost'];
    } else {
      throw Exception('Erro ao criar post');
    }
  }

  Future<bool> deletePost(int id) async {
    const mutation = """
      mutation DeletePost(\$id: ID!) {
        deletePost(id: \$id)
      }
    """;

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'query': mutation,
        'variables': {'id': id},
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log(data.toString());
      final success = data['data']['deletePost'] as bool;
      return success;
    } else {
      throw Exception('Erro: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getPostById(int id) async {
    const queryGetPostById = """
      query GetPostById(\$id: ID!) {
        post(id: \$id) {
          id
          title
          body
        }
      }
    """;

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query': queryGetPostById,
        'variables': {'id': id}
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data']['post'];
    } else {
      throw Exception('Erro ao carregar post');
    }
  }
}
