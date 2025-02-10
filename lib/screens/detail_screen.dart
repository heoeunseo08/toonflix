import 'package:flutter/material.dart';
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:html_unescape/html_unescape.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;
  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  final HtmlUnescape unescape = HtmlUnescape();

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      width: 250,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            offset: const Offset(10, 10),
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.3),
                          )
                        ],
                      ),
                      child: Image.network(widget.thumb),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              FutureBuilder<WebtoonDetailModel>(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        FutureBuilder(
                          future: episodes,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  for (var episode in snapshot.data!.length > 10
                                      ? snapshot.data!.sublist(0, 10)
                                      : snapshot.data!)
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.green.shade400,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 5,
                                              offset: Offset(5, 5),
                                              color:
                                                  // ignore: deprecated_member_use
                                                  Colors.black.withOpacity(0.3),
                                            )
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                unescape.convert(
                                                  episode.title,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Icon(Icons.chevron_right_rounded,
                                                color: Colors.white),
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                      ],
                    );
                  }
                  return Text("...");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
