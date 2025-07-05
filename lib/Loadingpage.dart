import 'package:demosapp/Homepage.dart';
import 'package:demosapp/Loginpage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class Loadingscreen extends StatefulWidget {
  const Loadingscreen({super.key});

  @override
  _LoadingscreenState createState() => _LoadingscreenState();
}

class _LoadingscreenState extends State<Loadingscreen> {
  bool _isInitializing = true;
  String _displayText = '';
  final String _targetText = 'Initializing app';
  Timer? _animationTimer;
  final Random _random = Random();
  int _currentIndex = 0;

  // Karakter acak untuk animasi
  final String _randomChars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#\$%^&*()';

  @override
  void initState() {
    super.initState();
    _startTextAnimation();
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  void _startTextAnimation() {
    _displayText = '';
    _currentIndex = 0;

    _animationTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_currentIndex < _targetText.length) {
          // Fase animasi karakter acak
          String newText = '';

          // Tambahkan karakter yang sudah fix
          for (int i = 0; i < _currentIndex; i++) {
            newText += _targetText[i];
          }

          // Tambahkan karakter acak untuk posisi saat ini
          if (_currentIndex < _targetText.length) {
            // Berikan efek acak untuk beberapa frame sebelum karakter asli muncul
            if (_random.nextInt(3) == 0) {
              // 1/3 kemungkinan tampilkan karakter asli
              newText += _targetText[_currentIndex];
              _currentIndex++;
            } else {
              // 2/3 kemungkinan tampilkan karakter acak
              if (_targetText[_currentIndex] == ' ') {
                newText += ' ';
                _currentIndex++;
              } else {
                newText += _randomChars[_random.nextInt(_randomChars.length)];
              }
            }
          }

          _displayText = newText;
        } else {
          // Animasi selesai, tunggu 1 detik lalu pindah ke halaman chat
          timer.cancel();
          Timer(Duration(seconds: 1), () {
            // Navigasi ke halaman chat
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ChatWhatsApp(),
              ),
            );
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildInitializingScreen(),
    );
  }

  Widget _buildInitializingScreen() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade800,
            Colors.green.shade400,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo atau ikon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.chat,
              size: 40,
              color: Colors.green.shade800,
            ),
          ),
          SizedBox(height: 20),

          // Nama aplikasi
          Text(
            'WhatsApp Clone',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 30),

          // Animasi teks
          Container(
            height: 60,
            child: Center(
              child: Text(
                _displayText,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                  fontFamily: 'monospace',
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          SizedBox(height: 40),

          // Loading indicator
          Container(
            width: 200,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              width: (200 * _currentIndex / _targetText.length).clamp(0, 200),
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          SizedBox(height: 20)
        ],
      ),
    );
  }
}
