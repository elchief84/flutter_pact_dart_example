import 'package:flutter/material.dart';
import 'package:pact_example/resository.dart';

import 'book.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Pact Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<Book>_books = [];

  void _addBook() {
    final alert = AlertDialog(
      title: const Text('Add a new Book'),
      content: Column(
        children: [
          TextField(
            controller: titleController,
            autofocus: true,
            decoration: const InputDecoration(
                hintText: "Title"),
          ),
          TextField(
            controller: descriptionController,
            autofocus: true,
            decoration: const InputDecoration(
                hintText: "Description (optional)"),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () async {
            Book? tmp = await Repository.book(
                title: titleController.text,
                description: descriptionController.text.isNotEmpty ? descriptionController.text : null
            );
            if(tmp != null) {
              setState(() {
                _books.add(tmp);
              });
            } else {
              if(mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("An error occurred during book creation!"),
                ));
              }
            }
            if(mounted) { Navigator.pop(context); }
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async { _books = await Repository.books() ?? []; },
        child: FutureBuilder<List<Book>?>(
          future: Repository.books(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                _books = snapshot.data ?? [];
                return ListView.builder(
                    itemCount: _books.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_books.reversed.toList()[index].title),
                        subtitle: Text(_books.reversed.toList()[index].description ?? ''),
                      );
                    }
                );
              }
              return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return const ListTile(title: Text('No books found!'));
                  }
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        child: const Icon(Icons.add),
      ),
    );
  }
}
