import 'dart:async';
import 'package:flutter/material.dart';
import 'package:informa2/modules/radio/models/radio_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class MyAudioService extends ChangeNotifier {
  static final MyAudioService _instance = MyAudioService._internal();
  factory MyAudioService() => _instance;
  MyAudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  //Controlador para la estación actual
  final _radioController = StreamController<RadioModel?>.broadcast();
  Stream<RadioModel?> get currentRadioStream => _radioController.stream;
  RadioModel? _currentRadio;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<IcyMetadata?> get metadataStream => _player.icyMetadataStream;
  // Método get para obtener la radio actual
  RadioModel? get currentRadio => _currentRadio;
  // Método para poner una radio actual
  void setCurrentRadio(RadioModel? radio) {
    _currentRadio = radio;
    _radioController.add(radio);
    notifyListeners();
    print("Radio actualizada: ${radio?.name}");
  }

  Future<void> playStream(RadioModel radio) async {
    await _player.stop(); 
    _currentRadio = radio;
    _radioController.add(radio);
    notifyListeners();

    try {

      print("Reproduciendo: ${radio.name} - ${radio.streamingUrl}");
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(radio.streamingUrl),
          // Creación de la notificación
          tag: MediaItem(
            id: radio.streamingUrl,
            album: radio.acronimo,
            title: radio.name,
            artist: radio.slogan,
            artUri: Uri.parse(radio.imageUrl),
          ),
        ),
      );

      _player.play();
    } catch (e) {
      print("Error: $e");
    }
  }


  Future<void> pause() => _player.pause();
  Future<void> play() => _player.play();
  Future<void> previous() => _player.seekToPrevious();
  Future<void> next() => _player.seekToNext();
}