import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatWhatsApp extends StatefulWidget {
  const ChatWhatsApp({super.key});

  @override
  State<ChatWhatsApp> createState() => _ChatWhatsAppState();
}

class _ChatWhatsAppState extends State<ChatWhatsApp> {
  var chatIndex = 0;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [
    {
      'text': 'Halo, apa kabar?',
      'time': '10:30',
      'isOutgoing': false,
    },
    {
      'text': 'Gimana kabar kamu hari ini?',
      'time': '10:31',
      'isOutgoing': false,
    },
    {
      'text': 'Halo juga! Alhamdulillah baik',
      'time': '10:32',
      'isOutgoing': true,
    },
    {
      'text': 'Kamu gimana? Semoga sehat selalu ya',
      'time': '10:33',
      'isOutgoing': true,
    },
    {
      'text': 'Amin, makasih ya. Kamu juga sehat selalu',
      'time': '10:34',
      'isOutgoing': false,
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengirim pesan
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    String userMessage = _messageController.text.trim();
    String currentTime = _getCurrentTime();

    setState(() {
      // Tambah pesan user
      messages.add({
        'text': userMessage,
        'time': currentTime,
        'isOutgoing': true,
      });
    });

    _messageController.clear();
    _scrollToBottom();

    // Kirim ke Rasa bot dan dapatkan respons
    _getRasaResponse(userMessage);
  }

  // Fungsi untuk mendapatkan respons dari Rasa bot
  Future<void> _getRasaResponse(String userMessage) async {
    try {
      // URL endpoint Rasa bot (sesuaikan dengan setup Rasa Anda)
      const String rasaUrl = 'http://localhost:5005/webhooks/rest/webhook';

      final response = await http.post(
        Uri.parse(rasaUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'sender': 'user',
          'message': userMessage,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        if (responseData.isNotEmpty) {
          String botResponse =
              responseData[0]['text'] ?? 'Maaf, saya tidak mengerti.';

          // Simulasi delay untuk respons yang lebih natural
          await Future.delayed(Duration(milliseconds: 500));

          setState(() {
            messages.add({
              'text': botResponse,
              'time': _getCurrentTime(),
              'isOutgoing': false,
            });
          });

          _scrollToBottom();
        }
      } else {
        // Jika Rasa bot tidak tersedia, berikan respons default
        _getDefaultResponse(userMessage);
      }
    } catch (e) {
      log('Error connecting to Rasa bot: $e');
      // Jika ada error, berikan respons default
      _getDefaultResponse(userMessage);
    }
  }

  // Fungsi untuk respons default jika Rasa bot tidak tersedia
  void _getDefaultResponse(String userMessage) {
    List<String> defaultResponses = [
      'Terima kasih atas pesannya!',
      'Maaf, saya sedang sibuk. Nanti saya balas ya.',
      'Saya mengerti maksud Anda.',
      'Boleh dijelaskan lebih detail?',
      'Saya akan membantu Anda.',
    ];

    // Pilih respons berdasarkan kata kunci
    String response;
    if (userMessage.toLowerCase().contains('halo') ||
        userMessage.toLowerCase().contains('hai')) {
      response = 'Halo juga! Ada yang bisa saya bantu?';
    } else if (userMessage.toLowerCase().contains('terima kasih') ||
        userMessage.toLowerCase().contains('thanks')) {
      response = 'Sama-sama! Senang bisa membantu.';
    } else if (userMessage.toLowerCase().contains('selamat')) {
      response = 'Selamat pagi/siang/sore juga!';
    } else {
      response = defaultResponses[userMessage.length % defaultResponses.length];
    }

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        messages.add({
          'text': response,
          'time': _getCurrentTime(),
          'isOutgoing': false,
        });
      });
      _scrollToBottom();
    });
  }

  // Fungsi untuk mendapatkan waktu saat ini
  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  // Fungsi untuk scroll ke bawah
  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WhatsApp Chat'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Aksi untuk tombol lebih banyak
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'WhatsApp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Chats'),
              onTap: () {
                // Aksi untuk menu Chats
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Groups'),
              onTap: () {
                // Aksi untuk menu Groups
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Aksi untuk menu Settings
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   padding: EdgeInsets.all(10),
            //   color: const Color.fromARGB(255, 211, 202, 202),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Column(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Icon(
            //             Icons.chat,
            //             size: 30,
            //             color: Colors.grey,
            //           ),
            //           SizedBox(
            //             height: 5,
            //           ),
            //           Icon(
            //             Icons.update,
            //             size: 30,
            //             color: Colors.grey,
            //           ),
            //           SizedBox(
            //             height: 5,
            //           ),
            //           Icon(
            //             Icons.chat_bubble_outline,
            //             size: 30,
            //             color: Colors.grey,
            //           ),
            //           SizedBox(
            //             height: 5,
            //           ),
            //           Icon(
            //             Icons.people_alt_rounded,
            //             size: 30,
            //             color: Colors.grey,
            //           ),
            //         ],
            //       ),
            //       Column(
            //         children: [
            //           Icon(
            //             Icons.settings,
            //             size: 30,
            //             color: Colors.grey,
            //           ),
            //           SizedBox(
            //             height: 5,
            //           ),
            //           Container(
            //             width: 30,
            //             height: 30,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(60),
            //               color: Colors.green,
            //             ),
            //           )
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              width: 15,
            ),
            Flexible(
              // flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Whatsapp",
                  //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  // ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    margin: EdgeInsets.zero,
                    width: 450,
                    height: 50,
                    color: Colors.white,
                    child: TextField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(80)),
                        hintText: "Cari atau mulai pesan baru",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(80)),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildChoiceChip("All", 0),
                      buildChoiceChip("Unread", 1),
                      buildChoiceChip("Read", 2),
                      buildChoiceChip("Group", 3)
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://media.licdn.com/dms/image/v2/C4D0BAQFfqSED4n1XiQ/company-logo_200_200/company-logo_200_200/0/1630491895803/rasa_logo?e=2147483647&v=beta&t=_B_tZy2PVwNwRdPaNsyV54GBCvXjA8fytWeseN39bSU'),
                              fit: BoxFit.cover,
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("Chat Bot App Dev"), Text("Online")],
                      )
                    ],
                  )
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Header Chat
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://media.licdn.com/dms/image/v2/C4D0BAQFfqSED4n1XiQ/company-logo_200_200/company-logo_200_200/0/1630491895803/rasa_logo?e=2147483647&v=beta&t=_B_tZy2PVwNwRdPaNsyV54GBCvXjA8fytWeseN39bSU'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Chat Bot App Dev",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Online",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Icon(Icons.videocam, color: Colors.grey[600]),
                              SizedBox(width: 16),
                              Icon(Icons.call, color: Colors.grey[600]),
                              SizedBox(width: 16),
                              Icon(Icons.more_vert, color: Colors.grey[600]),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Chat Messages
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: message['isOutgoing']
                                  ? buildOutgoingMessage(
                                      message['text'], message['time'])
                                  : buildIncomingMessage(
                                      message['text'], message['time']),
                            );
                          },
                        ),
                      ),
                    ),
                    // Input Message
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border(
                          top: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.emoji_emotions, color: Colors.grey[600]),
                          SizedBox(width: 8),
                          Icon(Icons.attach_file, color: Colors.grey[600]),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: "Ketik pesan...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              onSubmitted: (value) => _sendMessage(),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.send, color: Colors.white),
                              onPressed: _sendMessage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildChoiceChip(String label, int index) {
    return ChoiceChip(
      label: Text(label),
      selected: chatIndex == index,
      onSelected: (value) {
        setState(() {
          chatIndex = index;
        });
      },
    );
  }

  Widget buildIncomingMessage(String message, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(right: 50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOutgoingMessage(String message, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(left: 50),
        decoration: BoxDecoration(
          color: Color(0xFFDCF8C6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.done_all,
                  size: 12,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
