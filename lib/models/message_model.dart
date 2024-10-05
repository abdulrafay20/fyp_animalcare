class Message {
  final String image;
  final String lastMsg;
  final String senderName;
  final DateTime time;

  Message(
      {required this.image, required this.senderName, required this.lastMsg, required this.time,});
}
