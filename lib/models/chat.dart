class Chatters {
  final String messengerid1;
  final String messengerid2;
  

  Chatters({this.messengerid1, this.messengerid2});

  Chatters.fromData(Map<String, dynamic> data)
      : messengerid1 = data['messengerid1'],
        messengerid2 = data['messengerid2'];

  Map<String, dynamic> toJson() {
    return {
      'messengerid1': messengerid1,
      'messengerid2': messengerid2,
      
    };
  }
}
