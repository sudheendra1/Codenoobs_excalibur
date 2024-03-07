import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class First_aid extends StatefulWidget {
  const First_aid(
      {super.key,
      required this.info,
      required this.fname,
      required this.url,
      required this.steps});

  final info;
  final fname;
  final url;
  final steps;

  @override
  State<StatefulWidget> createState() {
    return _Firstaidstate();
  }
}

class _Firstaidstate extends State<First_aid> {
  late YoutubePlayerController _controller;

  List<String> parseInstructions(String paragraph) {

    List<RegExpMatch> matches = RegExp(r'\d+\)').allMatches(paragraph).toList();

    if (matches.isEmpty) return [paragraph.trim()];

    List<String> steps = [];
    for (int i = 0; i < matches.length; i++) {

      int start = matches[i].end;
      int end = (i == matches.length - 1) ? paragraph.length : matches[i + 1].start;
      steps.add(paragraph.substring(start, end).trim());
    }


    return steps.where((step) => step.isNotEmpty).toList();
  }


  @override
  void initState() {
    final videoid = YoutubePlayer.convertUrlToId(widget.url);
    _controller = YoutubePlayerController(
        initialVideoId: videoid!,
        flags: YoutubePlayerFlags(
          autoPlay: true,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> steps = parseInstructions(widget.steps);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Basic info:",
                  style: TextStyle(
                      fontFamily: 'Cocogoose',
                      color: Color.fromARGB(100, 11, 143, 172)),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(widget.info),
                SizedBox(
                  height: 20,
                ),
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(
                      isExpanded: true,
                      colors: ProgressBarColors(
                          playedColor: Colors.redAccent, handleColor: Colors.red),
                    ),
                    RemainingDuration(),
                    FullScreenButton(),
                    PlaybackSpeedButton(),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Steps:"),
                SizedBox(
                  height: 20,
                ),
                Column(

                  children: steps.expand((step) => [Text(step),SizedBox(height: 10,)]).toList(),
                )

                //Text(widget.steps),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
