import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Blog {
  String title;
  String content;
  String author;
  String imageURL;

  Blog({required this.title, required this.author, required this.content, required this.imageURL});
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

// Future<List<Blog>> getBlogs(String authToken) async {
  Future<List<Blog>> getBlogs() async {
  final response = await http.get(
    // Uri.parse('http://localhost:8000/blogs/1/'),
    Uri.parse('https://rakshika.onrender.com/blogs/1/'),
    headers: {
      'accept': 'application/json',
      // 'Authorization': 'Token $authToken',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    // print(data);
    final blogs = data.map<Blog>((blogData) {
      return Blog(
        title: blogData['title'],
        content: blogData['content'],
        author: blogData['author'],
        imageURL: blogData['image'] ?? "",
      );
    }).toList();
    // print(blogs);
    return blogs;
  } else {
    throw Exception('Failed to load blogs');
  }
}

// final List<Blog> blogDisplay = [
//   Blog(
//     title: 'First Blog ',
//     content: 'This is the content of the first blog ...',
//     author: 'Vidhi K',
//   ),
//   Blog(
//     title: 'Second Blog ',
//     content: 'This is the content of the second blog ...',
//     author: 'Vidhi K',
//   ),
// ];
List<Blog> blogDisplay = [];

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  void initState() {
    super.initState();
    getBlogs().then((blogs) {
      setState(() {
        // print(100);
        blogDisplay = blogs;
      });
    });
  }
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
