import 'package:bloc/bloc.dart';
import 'package:flutter_ui_music_player/main.dart';

abstract class MusicState {}

class MusicInitial extends MusicState {}

class MusicUpdateProgress extends MusicState {
  final int progressSecond;
  final double progressMusic;

  MusicUpdateProgress(this.progressSecond, this.progressMusic);
}

class MusicEndProgress extends MusicState {}

abstract class MusicEvent {}

class MusicStart extends MusicEvent {
  final Music music;

  MusicStart(this.music);
}

class MusicUpdate extends MusicEvent {}

class MusicEnd extends MusicEvent {}

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  Music music;
  int progressSecond;
  double progressMusic;

  @override
  MusicState get initialState => MusicInitial();

  @override
  Stream<MusicState> mapEventToState(MusicEvent event) async* {
    if (event is MusicStart) {
      music = event.music;
      progressSecond = 0;
      progressMusic = 0;
      yield MusicUpdateProgress(progressSecond, progressMusic);
    } else if (event is MusicUpdate) {
        progressSecond += 1;
        progressMusic = (progressSecond / music.durationSecond) * 100;
        print('progressSecond: $progressSecond');
      yield MusicUpdateProgress(progressSecond, progressMusic);
    } else if (event is MusicEnd) {
      yield MusicEndProgress();
    }
  }

}

