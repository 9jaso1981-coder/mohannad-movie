import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../movies/domain/usecases/get_stream_sources.dart';
import '../../domain/entities/stream_source.dart';

// ---------------- Events ----------------
sealed class PlayerEvent extends Equatable {
  const PlayerEvent();
  @override
  List<Object?> get props => [];
}

class LoadStreamSources extends PlayerEvent {
  final String identifier;
  const LoadStreamSources(this.identifier);
  @override
  List<Object?> get props => [identifier];
}

class ChangeQuality extends PlayerEvent {
  final StreamSource source;
  const ChangeQuality(this.source);
  @override
  List<Object?> get props => [source];
}

// ---------------- States ----------------
sealed class PlayerState extends Equatable {
  const PlayerState();
  @override
  List<Object?> get props => [];
}

class PlayerInitial extends PlayerState {}

class PlayerLoading extends PlayerState {}

class PlayerReady extends PlayerState {
  final List<StreamSource> sources;
  final StreamSource current;
  const PlayerReady({required this.sources, required this.current});
  @override
  List<Object?> get props => [sources, current];
}

class PlayerError extends PlayerState {
  final String message;
  const PlayerError(this.message);
  @override
  List<Object?> get props => [message];
}

// ---------------- Bloc ----------------
class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final GetStreamSources getStreamSources;

  PlayerBloc(this.getStreamSources) : super(PlayerInitial()) {
    on<LoadStreamSources>(_onLoad);
    on<ChangeQuality>(_onChangeQuality);
  }

  Future<void> _onLoad(LoadStreamSources event, Emitter<PlayerState> emit) async {
    emit(PlayerLoading());
    final result = await getStreamSources(event.identifier);
    result.fold(
      (failure) => emit(PlayerError(failure.message)),
      (sources) {
        if (sources.isEmpty) {
          emit(const PlayerError('No playable file found for this title.'));
          return;
        }
        // Default to 720p if available, else the highest available quality.
        final preferred = sources.firstWhere(
          (s) => s.label == '720p',
          orElse: () => sources.first,
        );
        emit(PlayerReady(sources: sources, current: preferred));
      },
    );
  }

  void _onChangeQuality(ChangeQuality event, Emitter<PlayerState> emit) {
    final state = this.state;
    if (state is PlayerReady) {
      emit(PlayerReady(sources: state.sources, current: event.source));
    }
  }
}
