import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:soncore/main.dart';
import 'package:soncore/routes/albums.dart';
import 'package:soncore/routes/home.dart';
import 'package:soncore/routes/playlists.dart';
import 'package:soncore/routes/songscreen.dart';
import 'package:soncore/routes/songs.dart';

class Routes extends StatefulWidget {
  void Function() showplaying;

  void Function() inititems;
  void Function() sort;
  Future<void> Function() getitems;
  void Function(int) play;
  void Function() playpause;
  void Function(String) showqueries;
  void Function() raisefrac;
  void Function() gonext;
  void Function() goprevious;
  void Function() clear;

  int index;
  Routes(
      {super.key,
      required this.index,
      required this.showplaying,
      required this.clear,
      required this.getitems,
      required this.gonext,
      required this.goprevious,
      required this.inititems,
      required this.play,
      required this.playpause,
      required this.raisefrac,
      required this.showqueries,
      required this.sort});
  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  List<Widget> routes = [];
  @override
  void initState() {
    super.initState();
    routes.add(HomePage());
    routes.add(SongsPage(
        showplaying: widget.showplaying,
        clear: widget.clear,
        getitems: widget.getitems,
        gonext: widget.gonext,
        goprevious: widget.goprevious,
        inititems: widget.inititems,
        play: widget.play,
        playpause: widget.playpause,
        raisefrac: widget.raisefrac,
        showqueries: widget.showqueries,
        sort: widget.sort));
    routes.add(AlbumsPage());
    routes.add(PlaylistsPage());
    // routes.add(PlayingScreen(
    //     positionDataStream: widget.positionDataStream,
    //     nowplaying: widget.nowplaying,
    //     icon: widget.icon,
    //     gonext: widget.gonext,
    //     goprevious: widget.goprevious,
    //     playpause: widget.playpause));
  }

  @override
  Widget build(BuildContext context) {
    return routes[widget.index];
  }
}
