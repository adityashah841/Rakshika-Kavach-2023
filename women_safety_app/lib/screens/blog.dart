import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

class Blog {
  String title;
  String content;
  String author;

  Blog({required this.title, required this.author, required this.content});
}

// class Blogdisplay {
//   Future<List<Blog>> fetchBlogs() async {
//     // final response = await http.get('');
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return List<Blog>.from(data.map((post) => Blog(
//             title: post['title'],
//             content: post['content'],
//             author: post['author'],
//           )));
//     } else {
//       throw Exception('Failed to load blog posts');
//     }
//   }
// }

final List<Blog> blogDisplay = [
  Blog(
    title: 'First Blog ',
    content: 'This is the content of the first blog ...',
    author: 'Vidhi K',
  ),
  Blog(
    title: 'Second Blog ',
    content: 'This is the content of the second blog ...',
    author: 'Vidhi K',
  ),
];

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
      ),
      body: ListView.builder(
        itemCount: blogDisplay.length,
        itemBuilder: (context, index) {
          final post = blogDisplay[index];
          return InkWell(
            onTap: () {
              // Navigate to a detailed view of the blog post if needed.
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text('By ${post.author}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
