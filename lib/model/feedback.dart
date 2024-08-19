class Feed {
  final String feed;
  final String subject;
  final String teename;
  final double rate;
  Feed({required this.feed, required this.subject, required this.teename, required this.rate});

  Map<String, String> toMap() =>
      {'fd': this.feed, 'sb': this.subject, 'tn': this.teename};

  Feed.fromMap(Map<String, String> map)
      : feed = map['fd'].toString(),
        subject = map['sb'].toString(),
        teename = map['tn'].toString(),
        rate = double.parse(map['rt'].toString());
}

List<Feed> extractFeed(var feedbackMap) {
  List<Feed> feedData = List.generate(feedbackMap.length, (index) {
  return Feed(
      feed: feedbackMap[index]['fd'].toString(),
      subject: feedbackMap[index]['sb'].toString(),
      teename: feedbackMap[index]['tn'].toString(),
      rate: double.parse(feedbackMap[index]['rt'].toString()));
});

  return feedData;
}

class FeedList {
  List<dynamic> fdb = [];

  FeedList({
    required this.fdb,
  });

  Map<String, dynamic> toMap() => {
        "fdb": this.fdb,
      };

  // FeedList.fromMap(Map<dynamic, dynamic> map)
  //     : fdb = map['feed'].map((fd) {
  //         return Feed.fromMap(fd);
  //       }).toList();
}
