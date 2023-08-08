import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Blog {
  String title;
  String content;
  String author;
  String imageURL;

  Blog(
      {required this.title,
      required this.author,
      required this.content,
      required this.imageURL});
}

Future<List<Blog>> getBlogs() async {
  final response = await http.get(
    // Uri.parse('http://localhost:8000/blogs/1/'),
    Uri.parse('https://rakshika.onrender.com/blogs/1/'),
    headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxNzI4NDU0LCJpYXQiOjE2OTE0NjkyNTQsImp0aSI6ImY3MzYyMzc5Y2I5MTQ1MTM4OWM0MDU2M2ZlMjY3ODE4IiwidXNlcl9pZCI6NX0.LmamNhJ_rMYSSeygaB677gxVCjSBpsxUSjJU0XaHO9U',
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

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<Blog> blogDisplay = [];
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
                  // Display the minimized image
                  post.imageURL.isNotEmpty
                      ? SizedBox(
                          height: 150, // Set the desired height
                          width: double
                              .infinity, // Match the width of the container
                          child: Image.network(
                            post.imageURL,
                            fit:
                                BoxFit.cover, // Adjust the image's aspect ratio
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 8.0),
                  Text(
                    post.title,
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12.0),
                  Text(post.content),
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
