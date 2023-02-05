// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:soncore/main.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:just_audio_background/just_audio_background.dart';

class PlayingScreen extends StatefulWidget {
  Future<void> Function() goprevious;
  void Function() playpause;
  Future<void> Function() gonext;
  void Function() update;

  PlayingScreen(
      {super.key,
      required this.update,
      required this.gonext,
      required this.goprevious,
      required this.playpause});

  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var icon;
  bool? wasplaying;
  bool lyrics = false;

  @override
  void initState() {
    super.initState();
    icon = player.playing ? Icons.pause : Icons.play_arrow;
    wasplaying = hasplayed;
    hasplayed = false;
    barheight = 0;
  }

  @override
  void dispose() {
    hasplayed = wasplaying!;
    barheight = 80;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (lyrics) {
          setState(() {
            lyrics = false;
          });
          return false;
        }
        setState(() {
          selected = previous;
        });
        widget.update();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 150,
                ),
                StreamBuilder(
                  stream: player.sequenceStateStream,
                  builder: ((context, snapshot) {
                    final sequenceState = snapshot.data;
                    if (sequenceState?.sequence.isEmpty ?? true) {
                      return const SizedBox.shrink();
                    }
                    final metadata =
                        sequenceState!.currentSource!.tag as MediaItem;
                    return Column(
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  lyrics = true;
                                });
                              },
                              child: Image.network(
                                'http://kwak.sytes.net/v0/cover/${metadata.id}',
                                width: 300,
                                height: 300,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        Center(
                            child: SizedBox(
                          width: 311,
                          child: Center(
                            child: TextScroll(
                              metadata.title,
                              style: const TextStyle(fontSize: 30),
                              velocity: const Velocity(
                                  pixelsPerSecond: Offset(30, 0)),
                              textAlign: TextAlign.center,
                              intervalSpaces: 15,
                            ),
                          ),
                        )),
                        Container(
                          height: 20,
                        ),
                        Center(
                            child: SizedBox(
                          width: 311,
                          child: Center(
                            child: TextScroll(
                              '${metadata.artist}',
                              style: const TextStyle(fontSize: 20),
                              velocity: const Velocity(
                                  pixelsPerSecond: Offset(30, 0)),
                              textAlign: TextAlign.center,
                              intervalSpaces: 15,
                            ),
                          ),
                        )),
                      ],
                    );
                  }),
                ),
                Container(
                  height: 35,
                ),
                SizedBox(
                  width: 300,
                  child: StreamBuilder<PositionData>(
                    stream: positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return ProgressBar(
                        total: positionData?.duration ?? Duration.zero,
                        progress: positionData?.position ?? Duration.zero,
                        buffered:
                            positionData?.bufferedPosition ?? Duration.zero,
                        onSeek: player.seek,
                        barHeight: 7,
                      );
                    },
                  ),
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.skip_previous),
                      onPressed: () async {
                        await widget.goprevious();
                        setState(() {});
                      },
                    ),
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        iconSize: 55,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        icon: Icon(icon),
                        onPressed: () {
                          widget.playpause();
                          setState(() {
                            icon = icon == Icons.play_arrow
                                ? Icons.pause
                                : Icons.play_arrow;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.skip_next),
                      onPressed: () async {
                        await widget.gonext();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
            lyrics
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        lyrics = false;
                      });
                    },
                    child: ListView(children: [
                      Container(height: 25),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Center(
                          child: SizedBox(
                            width: 311,
                            child: Center(
                                child: Text(
                                    nowplaying['lyrics'] != null
                                        ? nowplaying['lyrics'][0] ??
                                            'No Lyrics Found'
                                        : 'No Lyrics Found',
                                    style: const TextStyle(fontSize: 20))),
                          ),
                        ),
                      ),
                      Container(height: 25),
                    ]),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
