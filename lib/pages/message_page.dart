import 'package:flutter/material.dart';
import 'package:fyp_animalcare_app/models/message_model.dart';
import 'package:intl/intl.dart';

class MessagePage extends StatefulWidget {
  MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Message> message = [
    Message(
        image:
            'https://as2.ftcdn.net/v2/jpg/05/89/93/27/1000_F_589932782_vQAEAZhHnq1QCGu5ikwrYaQD0Mmurm0N.jpg',
        senderName: 'Jinsar',
        lastMsg: 'Hi',
        time: DateTime.now()),
    Message(
        image:
            'https://as2.ftcdn.net/v2/jpg/05/89/93/27/1000_F_589932782_vQAEAZhHnq1QCGu5ikwrYaQD0Mmurm0N.jpg',
        senderName: 'Ali',
        lastMsg: 'Hello',
        time: DateTime.now()),
    Message(
        image:
            'https://as2.ftcdn.net/v2/jpg/05/89/93/27/1000_F_589932782_vQAEAZhHnq1QCGu5ikwrYaQD0Mmurm0N.jpg',
        senderName: 'Taha',
        lastMsg: 'Lumsi',
        time: DateTime.now()),
    Message(
        image:
            'https://as2.ftcdn.net/v2/jpg/05/89/93/27/1000_F_589932782_vQAEAZhHnq1QCGu5ikwrYaQD0Mmurm0N.jpg',
        senderName: 'Sam',
        lastMsg: 'Murshid',
        time: DateTime.now()),
    Message(
        image:
            'https://as2.ftcdn.net/v2/jpg/05/89/93/27/1000_F_589932782_vQAEAZhHnq1QCGu5ikwrYaQD0Mmurm0N.jpg',
        senderName: 'Danish',
        lastMsg: 'Bro',
        time: DateTime.now()),
    Message(
        image:
            'https://as2.ftcdn.net/v2/jpg/05/89/93/27/1000_F_589932782_vQAEAZhHnq1QCGu5ikwrYaQD0Mmurm0N.jpg',
        senderName: 'Jawad',
        lastMsg: 'Set',
        time: DateTime.now())
  ];

  List<Message> _list = [];
  @override
  void initState() {
    _list = message;
    super.initState();
  }

  void search(String input) {
    List<Message> result = [];
    if (input.isEmpty) {
      result = message;
    } else {
      result = message
          .where((user) =>
              user.senderName.toLowerCase().contains(input.toLowerCase()))
          .toList();
    }
    setState(() {
      _list = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        centerTitle: true,
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            width: 350,
            height: 40,
            child: TextField(
              cursorHeight: 18,
              onChanged: (value) => search(value),
              decoration: InputDecoration(
                  fillColor: Colors.grey[250],
                  filled: true,
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),
        ),
        Divider(),
        const SizedBox(height: 5),
        Expanded(
          child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                var currentMessage = _list[index];
                return ListTile(
                  shape: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]!)),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(currentMessage.image),
                  ),
                  title: Text(
                    currentMessage.senderName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(currentMessage.lastMsg),
                  trailing:
                      Text(DateFormat('HH:mm').format(currentMessage.time)),
                );
              }),
        ),
      ]),
    );
  }
}
