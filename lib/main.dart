import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'GoogleSheetFecthData'),
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
  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(Uri.parse(
        "https://script.googleusercontent.com/macros/echo?user_content_key=QaMFApUoCbQTcXj5nJwfgnlPPbCx-TS5jXzeffQVwFE1UbyGeLKHzrUG2w7Z57BmG_zxVRAx_ogA7I2yyeSralJzTMel3u-Im5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnC_OgmT6cp65fzD7CSHDlxOrMZFRiKoBbqrDHoo5qhGQRMTfMSDyFj5p09lakTqxCRhh4wFfRqSiTV8jCDhYCn7n6oMV7BTxmtz9Jw9Md8uu&lib=MCqtzRpUbzPAv5UZSauo9rnoLM9bSnHJz"));
    return jsonDecode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var title = snapshot.data[index]['title'].toString();
                  var band = snapshot.data[index]['band'].toString();
                  var release = snapshot.data[index]['release'].toString();
                  var label = snapshot.data[index]['label'].toString();

                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () => print(release),
                          title: Text(title),
                          subtitle: Text(band),
                          trailing: Text(label),
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
