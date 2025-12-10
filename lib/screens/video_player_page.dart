// lib/screens/video_player_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String stepText;
  final int stepDuration;
  final int stepSeekSeconds;
  final bool autoPlay;

  const VideoPlayerPage({
    Key? key,
    required this.videoUrl,
    required this.title,
    required this.stepText,
    required this.stepDuration,
    this.stepSeekSeconds = 10,
    this.autoPlay = true, // default to autoplay like your working example
  }) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _vController;
  Timer? _countdownTimer;
  int _remainingSeconds = 0;
  double _videoProgress = 0.0; // 0..1
  bool _isInitialized = false;
  bool _hasError = false;

  // small threshold to avoid rebuilding too often
  static const _progressEpsilon = 0.002;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.stepDuration;
    _initController();
  }

  Future<void> _initController() async {
    debugPrint('VideoPlayerPage: initializing controller for ${widget.videoUrl}');
    _vController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    try {
      await _vController.initialize(); // will decode first frame
      await _vController.setLooping(false);
      await _vController.setVolume(1.0);

      // attach listener after init
      _vController.addListener(_videoListener);

      // Optionally auto-play (mimic your working example)
      if (widget.autoPlay) {
        // call play after initialization
        await _vController.play();
      }

      setState(() {
        _isInitialized = true;
        _hasError = _vController.value.hasError;
        // set progress immediately from initial position
        if (_vController.value.duration.inMilliseconds > 0) {
          _videoProgress = (_vController.value.position.inMilliseconds / _vController.value.duration.inMilliseconds).clamp(0.0, 1.0);
        }
      });

      debugPrint('VideoPlayerPage: initialized (duration: ${_vController.value.duration}) playing=${_vController.value.isPlaying}');
    } catch (e) {
      debugPrint('VideoPlayerPage: initialization error: $e');
      setState(() {
        _hasError = true;
        _isInitialized = false;
      });
    }
  }

  void _videoListener() {
    if (!mounted) return;
    final value = _vController.value;

    if (value.hasError && !_hasError) {
      debugPrint('Video player error: ${value.errorDescription}');
      setState(() => _hasError = true);
    }

    if (value.duration.inMilliseconds > 0) {
      final progress = value.position.inMilliseconds / value.duration.inMilliseconds;
      final clamped = progress.isNaN ? 0.0 : progress.clamp(0.0, 1.0);

      // only trigger setState if progress changed enough
      if ((clamped - _videoProgress).abs() > _progressEpsilon) {
        setState(() => _videoProgress = clamped);
      }
    }

    // start/stop countdown via listener
    if (value.isPlaying && (_countdownTimer == null || !_countdownTimer!.isActive)) {
      _startCountdown();
    } else if (!value.isPlaying && (_countdownTimer?.isActive ?? false)) {
      _countdownTimer?.cancel();
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (!_vController.value.isInitialized) return;
      if (!_vController.value.isPlaying) return;

      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _countdownTimer?.cancel();
          _vController.pause();
        }
      });
    });
  }

  void _togglePlay() {
    if (!_vController.value.isInitialized) return;
    if (_vController.value.isPlaying) {
      _vController.pause();
    } else {
      _vController.play();
    }
    setState(() {}); // update play/pause icon immediately
  }

  void _seekBy(int seconds) {
    if (!_vController.value.isInitialized) return;
    final pos = _vController.value.position;
    final dur = _vController.value.duration;
    var target = pos + Duration(seconds: seconds);
    if (target < Duration.zero) target = Duration.zero;
    if (target > dur) target = dur;
    _vController.seekTo(target);
  }

  void _onSliderChangeEnd(double v) {
    if (!_vController.value.isInitialized) return;
    final dur = _vController.value.duration;
    final newPos = dur * v;
    _vController.seekTo(newPos);
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _vController.removeListener(_videoListener);
    _vController.dispose();
    super.dispose();
  }

  String _formatSeconds(int seconds) {
    final s = seconds % 60;
    final m = seconds ~/ 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    return '$m:$s';
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Icon(icon, color: Colors.black87, size: 22),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final purple = const Color(0xFF6C63FF);
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // TOP VIDEO / IMAGE area
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // show the VideoPlayer (first frame visible after initialize)
                  if (_isInitialized && !_hasError) ...[
                    AspectRatio(
                      aspectRatio: _vController.value.aspectRatio > 0 ? _vController.value.aspectRatio : (16 / 9),
                      child: VideoPlayer(_vController),
                    ),
                  ] else if (_hasError) ...[
                    Container(color: Colors.grey.shade300, child: const Center(child: Icon(Icons.broken_image, size: 56))),
                  ] else ...[
                    Container(color: Colors.grey.shade200),
                  ],

                  // slight gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.transparent, Colors.black.withOpacity(0.12)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    ),
                  ),

                  // top-left back
                  Positioned(left: 10, top: 10, child: _circleButton(icon: Icons.arrow_back, onTap: () => Navigator.of(context).pop())),

                  // top-right more
                  Positioned(right: 10, top: 10, child: _circleButton(icon: Icons.more_horiz, onTap: () {})),

                  // small purple progress line under image
                 // Positioned(left: 18, right: screenW - 18 - (screenW * 0.22), bottom: 120, child: Container(height: 4, decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(4)))),

                  // Center large play/pause control
                  // Positioned.fill(
                  //   child: Center(
                  //     child: GestureDetector(
                  //       onTap: _togglePlay,
                  //       child: Container(
                  //         width: 64,
                  //         height: 64,
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           shape: BoxShape.circle,
                  //           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8)],
                  //         ),
                  //         child: Center(
                  //           child: Icon((_isInitialized && _vController.value.isPlaying) ? Icons.pause : Icons.play_arrow, color: purple, size: 36),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            // BODY: Title, Step text, timer, slider and controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _isInitialized ? _videoProgress : 0.0,
                          onChanged: (v) => setState(() => _videoProgress = v),
                          onChangeEnd: (v) => _onSliderChangeEnd(v),
                          activeColor: purple,
                          inactiveColor: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),

                  Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(widget.stepText, style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 18),

                  // Big countdown timer centered
                  Center(child: Text(_formatSeconds(_remainingSeconds), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),

                  // Slider for video progress


                  const SizedBox(height: 6),

                  // Bottom controls: prev, play/pause, next
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(onPressed: () => _seekBy(-widget.stepSeekSeconds), icon: const Icon(Icons.chevron_left, size: 32), color: Colors.black54),
                      GestureDetector(
                        onTap: _togglePlay,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                          child: Center(child: Icon((_isInitialized && _vController.value.isPlaying) ? Icons.pause : Icons.play_arrow, color: purple, size: 28)),
                        ),
                      ),
                      IconButton(onPressed: () => _seekBy(widget.stepSeekSeconds), icon: const Icon(Icons.chevron_right, size: 32), color: Colors.black54),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
