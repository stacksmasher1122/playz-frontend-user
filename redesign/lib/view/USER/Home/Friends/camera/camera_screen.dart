import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:redesign/theme/app_colors.dart';

// Internal Widgets
import 'widgets/camera_top_bar.dart';
import 'widgets/camera_bottom_controls.dart';
import 'widgets/camera_capture_overlay.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInit = false;
  bool _isTakingPicture = false;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Hide status bars for full screen immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No camera available')),
          );
        }
        return;
      }
      _startCamera(_selectedCameraIndex);
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  Future<void> _startCamera(int index) async {
    _controller = CameraController(
      _cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
      // Important to call setState to rebuild after init
      if (mounted) setState(() => _isInit = true);
    } catch (e) {
      debugPrint("Camera initialize error: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    
    // Important: Handle lifecycle to prevent camera crash when backgrounded
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _startCamera(_selectedCameraIndex);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isTakingPicture) {
      return;
    }

    setState(() => _isTakingPicture = true);

    try {
      final XFile file = await _controller!.takePicture();
      if (mounted) {
        Navigator.pop(context, file.path); // Return path to ChatScreen
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
      setState(() => _isTakingPicture = false);
    }
  }

  void _switchCamera() async {
    if (_cameras.length < 2 || _controller == null) return;
    
    _isInit = false;
    setState(() {});
    
    await _controller!.dispose();
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    _startCamera(_selectedCameraIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Camera Preview ──
          Positioned.fill(
            child: CameraPreview(_controller!),
          ),

          // ── Top Controls ──
          const CameraTopBar(),

          // ── Bottom Controls ──
          CameraBottomControls(
            onCapture: _takePicture,
            onSwitchCamera: _switchCamera,
          ),
          
          // ── Loading Overlay (While capturing) ──
          if (_isTakingPicture)
            const CameraCaptureOverlay(),
        ],
      ),
    );
  }
}
