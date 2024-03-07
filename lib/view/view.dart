import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo_app/provider/provider.dart';
import 'package:todo_app/services/services.dart';
import 'package:todo_app/utils.dart';
import 'package:todo_app/view/componets/dialog_componet.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Stream? todoStream;
  final TextEditingController controller = TextEditingController();
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  String? _linkMessage;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getonTheLoad();
    });
    super.initState();
    initDynamicLinks();
  }

  getonTheLoad() async {
    todoStream = await Services().getTask();
    setState(() {});
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      // final Uri uri = dynamicLinkData.link;
      // final queryParams = uri.queryParameters;
      // if (queryParams.isNotEmpty) {
      //   String? productId = queryParams["id"];
      //   Navigator.pushNamed(context, dynamicLinkData.link.path, arguments: {"productId": int.parse(productId!)});
      // } else {
      Navigator.pushNamed(
        context,
        dynamicLinkData.link.path,
      );
      // }
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  Future<void> _createDynamicLink(bool short, String link) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: kUriPrefix,
      link: Uri.parse(kUriPrefix + link),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.deeplink',
        minimumVersion: 0,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    setState(() {
      _linkMessage = url.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          return StreamBuilder(
              stream: todoStream,
              builder: (context, AsyncSnapshot snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot docSnap = snapshot.data.docs[index];
                          return Card(
                            child: ListTile(
                              onLongPress: () async {
                                await _createDynamicLink(true, kHomePageLink);
                                if (_linkMessage != null) {
                                  Share.share(_linkMessage!);
                                }
                              },
                              title: Text(docSnap['title']),
                              onTap: () {
                                controller.text = docSnap['title'];
                                _showAddTodoDialog(context, docSnap.id);
                              },
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  ref.read(serviceProvider).delete(docSnap.id);
                                },
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.text = "";
          _showAddTodoDialog(context, null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context, String? id) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogComponent(
          controller: controller,
          id: id,
        );
      },
    );
  }
}
