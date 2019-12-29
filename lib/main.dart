import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_music_player/music_bloc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MusicBloc>(
      create: (context) => MusicBloc(),
      child: MaterialApp(
        home: MyApp(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final List<Music> listMusic = [
    Music('State of Grace', 'Taylor Swift', 296),
    Music('Red', 'Taylor Swift', 223),
    Music('Treacherous', 'Taylor Swift', 243),
    Music('I Knew You Were Trouble', 'Taylor Swift', 220),
    Music('All Too Well', 'Taylor Swift', 329),
    Music('22', 'Taylor Swift', 232),
    Music('I Almost Do', 'Taylor Swift', 245),
    Music('We Are Never Ever Getting Back Together', 'Taylor Swift', 193),
    Music('Stay Stay Stay', 'Taylor Swift', 206),
    Music('The Last Time - Gary Lightbody', 'Taylor Swift', 299),
    Music('Holy Ground', 'Taylor Swift', 203),
    Music('Sad Beautiful Tragic', 'Taylor Swift', 294),
    Music('The Lucky One', 'Taylor Swift', 240),
    Music('Everything Has Changed - Ed Sheeran', 'Taylor Swift', 245),
    Music('Starlight', 'Taylor Swift', 221),
    Music('Begin Again', 'Taylor Swift', 239),
    Music('The Moment I Knew', 'Taylor Swift', 287),
    Music('Come Back...Be Here', 'Taylor Swift', 224),
    Music('Girl At Home', 'Taylor Swift', 221),
    Music('Treacherous - Original Demo Recording', 'Taylor Swift', 240),
    Music('Red - Original Demo Recording', 'Taylor Swift', 227),
    Music('State Of Grace - Acoustic Version', 'Taylor Swift', 323),
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;
    double paddingBottom = mediaQueryData.padding.bottom;

    return Scaffold(
      body: Container(
        width: widthScreen,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                _buildWidgetBackgroundCoverAlbum(widthScreen, context),
                _buildWidgetListMusic(context, paddingBottom, widthScreen, heightScreen),
              ],
            ),
            _buildWidgetButtonPlayAll(),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetListMusic(BuildContext context, double paddingBottom, double widthScreen, double heightScreen) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: paddingBottom > 0 ? paddingBottom : 16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Colors.blueGrey.withOpacity(0.7),
              Colors.white70.withOpacity(0.7),
            ],
            stops: [0.1, 0.9],
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 48.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Playlist',
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                WidgetShuffle(),
                SizedBox(width: 24.0),
                WidgetRepeat(),
              ],
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  Music music = listMusic[index];
                  int durationMinute = music.durationSecond >= 60 ? music.durationSecond ~/ 60 : 0;
                  int durationSecond = music.durationSecond >= 60 ? music.durationSecond % 60 : music.durationSecond;
                  String strDuration = "$durationMinute:" + (durationSecond < 10 ? "0$durationSecond" : "$durationSecond");
                  return GestureDetector(
                    onTap: () {
                      _showMiniPlayer(context, widthScreen, heightScreen, paddingBottom, music);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  music.title,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${music.artist} • $strDuration',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.more_vert),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: listMusic.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMiniPlayer(BuildContext context, double widthScreen, double heightScreen, double paddingBottom, Music music) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return WidgetMiniPlayer(music, widthScreen, heightScreen, paddingBottom);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
    );
  }

  Widget _buildWidgetButtonPlayAll() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 92,
        decoration: BoxDecoration(
          color: Color(0xFFAE1947),
          borderRadius: BorderRadius.all(Radius.circular(48.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 10.0,
              color: Color(0xFFAE1947),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.play_arrow, color: Colors.white),
          onPressed: () {},
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildWidgetBackgroundCoverAlbum(double widthScreen, BuildContext context) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/img_cover_album_red_taylor_swift.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.0),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Colors.black.withOpacity(0.1),
                ],
                stops: [
                  0.0,
                  0.7,
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: widthScreen / 2.5,
              height: widthScreen / 2.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/img_cover_album_red_taylor_swift.jpeg'),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 15.0,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 28.0,
              height: 28.0,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(99)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                SizedBox(height: widthScreen / 1.45),
                SizedBox(height: 4.0),
                Text(
                  'Red (Deluxe Edition)',
                  style: Theme.of(context).textTheme.title.merge(TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 4.0),
                Text(
                  '22 Songs • 1 hr 30 min',
                  style: Theme.of(context).textTheme.subtitle.merge(TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetShuffle extends StatefulWidget {
  @override
  _WidgetShuffleState createState() => _WidgetShuffleState();
}

class _WidgetShuffleState extends State<WidgetShuffle> {
  bool _isShuffle = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _isShuffle = !_isShuffle);
      },
      child: Icon(
        Icons.shuffle,
        color: Color(_isShuffle ? 0xFFAE1947 : 0xFF000000),
      ),
    );
  }
}

class WidgetRepeat extends StatefulWidget {
  @override
  _WidgetRepeatState createState() => _WidgetRepeatState();
}

class _WidgetRepeatState extends State<WidgetRepeat> {
  bool _isRepeat = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _isRepeat = !_isRepeat);
      },
      child: Icon(
        Icons.repeat,
        color: _isRepeat ? Color(0xFFAE1947) : Color(0xFF000000),
      ),
    );
  }
}

class WidgetMiniPlayer extends StatefulWidget {
  final Music music;
  final double widthScreen;
  final double heightScreen;
  final double paddingBottom;

  WidgetMiniPlayer(this.music, this.widthScreen, this.heightScreen, this.paddingBottom);

  @override
  _WidgetMiniPlayerState createState() => _WidgetMiniPlayerState();
}

class _WidgetMiniPlayerState extends State<WidgetMiniPlayer> {
  MusicBloc _musicBloc;
  Timer timer;
  double _progressMusic = 0;

  @override
  void initState() {
    if (_musicBloc == null) {
      _musicBloc = BlocProvider.of<MusicBloc>(context);
    }
    _musicBloc.add(MusicStart(widget.music));
    if (timer == null || !timer.isActive) {
      timer = Timer.periodic(Duration(seconds: 1), (value) {
        print('progress music: ${value.tick}');
        _musicBloc.add(MusicUpdate());
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return WidgetDetailMusicPlayer();
          },
          isScrollControlled: true,
          isDismissible: false,
        );
      },
      child: BlocProvider.value(
        value: _musicBloc,
        child: Container(
          width: widget.widthScreen,
          padding: EdgeInsets.only(left: 16.0, top: 4.0, right: 16.0, bottom: widget.paddingBottom > 0 ? widget.paddingBottom : 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 28.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                ),
              ),
              SizedBox(height: 12.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Now Playing',
                          style: Theme.of(context).textTheme.subtitle.merge(TextStyle(color: Colors.grey)),
                        ),
                        Text('${widget.music.title}', style: Theme.of(context).textTheme.title),
                      ],
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      SizedBox(
                        width: 32.0,
                        height: 32.0,
                        child: BlocBuilder<MusicBloc, MusicState>(builder: (context, state) {
                          if (state is MusicUpdateProgress) {
                            _progressMusic = state.progressMusic;
                            int progressSecond = state.progressSecond;
                            if (progressSecond == widget.music.durationSecond) {
                              _progressMusic = 100;
                              timer.cancel();
                              _musicBloc.add(MusicEnd());
                            }
                          }
                          return SleekCircularSlider(
                            appearance: CircularSliderAppearance(
                              customWidths: CustomSliderWidths(
                                progressBarWidth: 2.0,
                                trackWidth: 1.0,
                                handlerSize: 1.0,
                                shadowWidth: 1.0,
                              ),
                              infoProperties: InfoProperties(
                                modifier: (value) => '',
                              ),
                              customColors: CustomSliderColors(
                                trackColor: Colors.grey,
                                progressBarColor: Colors.black,
                              ),
                              size: 4.0,
                              angleRange: 360,
                              startAngle: -90.0,
                            ),
                            min: 0.0,
                            max: 100.0,
                            initialValue: _progressMusic,
                          );
                        }),
                      ),
                      SizedBox(
                        width: 32.0,
                        height: 32.0,
                        child: BlocBuilder<MusicBloc, MusicState>(builder: (context, state) {
                          bool isPlaying = true;
                          if (state is MusicEndProgress) {
                            isPlaying = false;
                          }
                          return Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 20);
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WidgetDetailMusicPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;
    double paddingBottom = mediaQueryData.padding.bottom;

    return Container(
      width: widthScreen,
      height: heightScreen,
      child: Stack(
        children: <Widget>[
          _buildWidgetBackgroundCoverAlbum(widthScreen, heightScreen),
          _buildWidgetContainerContent(widthScreen, heightScreen),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            width: widthScreen,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 128.0 + 16.0),
                      Container(
                        width: 72.0,
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        child: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      ),
                      SizedBox(height: 24.0),
                      ClipRRect(
                        child: Image.asset(
                          'assets/images/img_cover_album_red_taylor_swift.jpeg',
                          width: widthScreen / 1.5,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(48.0)),
                      ),
                    ],
                  ),
                ),
                WidgetDetailTitleMusic(),
                SizedBox(height: 16.0),
                WidgetProgressMusic(),
                SizedBox(height: 16.0),
                _buildWidgetPlayerController(),
                SizedBox(height: 16.0),
                SizedBox(height: paddingBottom > 0 ? paddingBottom : 16.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetPlayerController() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.skip_previous, color: Colors.white, size: 32.0),
        SizedBox(width: 36.0),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blueGrey[800],
          ),
          padding: EdgeInsets.all(16.0),
          child: BlocBuilder<MusicBloc, MusicState>(
            builder: (context, state) {
              bool isPlaying = true;
              if (state is MusicEndProgress) {
                isPlaying = false;
              }
              return Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 32.0);
            },
          ),
        ),
        SizedBox(width: 36.0),
        Icon(Icons.skip_next, color: Colors.white, size: 32.0),
      ],
    );
  }

  Widget _buildWidgetContainerContent(double widthScreen, double heightScreen) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: widthScreen,
        height: heightScreen / 1.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(48.0), topRight: Radius.circular(48.0)),
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Colors.blueGrey[300],
              Colors.white,
            ],
            stops: [0.1, 0.9],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetBackgroundCoverAlbum(double widthScreen, double heightScreen) {
    return Container(
      width: widthScreen,
      height: heightScreen / 2,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/img_cover_album_red_taylor_swift.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: Container(
          color: Colors.white.withOpacity(0.0),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class WidgetProgressMusic extends StatelessWidget {
  double _progress = 0;
  int _durationProgress = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(builder: (context, state) {
      if (state is MusicUpdateProgress) {
        _progress = state.progressMusic / 100;
        _durationProgress = state.progressSecond;
      }
      int minute = _durationProgress ~/ 60;
      int second = minute > 0 ? _durationProgress % 60 : _durationProgress;
      String strDuration = (minute < 10 ? '0$minute' : '$minute') + ':' + (second < 10 ? '0$second' : '$second');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          LinearProgressIndicator(
            value: _progress,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            backgroundColor: Colors.blueGrey[800],
          ),
          Text(strDuration),
        ],
      );
    });
  }
}

class WidgetDetailTitleMusic extends StatefulWidget {
  @override
  _WidgetDetailTitleMusicState createState() => _WidgetDetailTitleMusicState();
}

class _WidgetDetailTitleMusicState extends State<WidgetDetailTitleMusic> {
  bool _isRepeatOne = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(BlocProvider.of<MusicBloc>(context).music.title, style: Theme.of(context).textTheme.title),
              Text(BlocProvider.of<MusicBloc>(context).music.artist,
                  style: Theme.of(context).textTheme.subtitle.merge(TextStyle(color: Colors.blueGrey))),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() => _isRepeatOne = !_isRepeatOne);
          },
          child: Icon(
            Icons.repeat_one,
            color: _isRepeatOne ? Color(0xFFAE1947) : Color(0xFF000000),
          ),
        ),
      ],
    );
  }
}

class Music {
  String title;
  String artist;
  int durationSecond;

  Music(this.title, this.artist, this.durationSecond);
}
