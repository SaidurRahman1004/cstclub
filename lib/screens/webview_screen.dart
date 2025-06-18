import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}


class _WebViewScreenState extends State<WebViewScreen> with SingleTickerProviderStateMixin {
  late final WebViewController _controller;
  int _loadingPercentage = 0;
  bool _hasError = false;
  WebResourceError? _error;

  
  late AnimationController _animationController;
  late Animation<Offset> _logoAnimation;

  final String webUrl = 'https://cst-club.org';

  bool _isDownloadable(String url) {
    final uri = Uri.parse(url);
    final path = uri.path.toLowerCase();
    return path.endsWith('.pdf') ||
        path.endsWith('.zip') ||
        path.endsWith('.rar') ||
        path.endsWith('.doc') ||
        path.endsWith('.docx') ||
        path.endsWith('.xls') ||
        path.endsWith('.xlsx') ||
        path.endsWith('.ppt') ||
        path.endsWith('.pptx') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.apk');
  }

  @override
  void initState() {
    super.initState();

    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _logoAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.05), 
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true); 

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() { _loadingPercentage = progress; });
          },
          onPageStarted: (String url) {
            setState(() {
              _loadingPercentage = 0;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() { _loadingPercentage = 100; });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _hasError = true;
              _error = error;
            });
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (_isDownloadable(request.url)) {
              _downloadFile(request.url);
              return NavigationDecision.prevent;
            }
            if (!request.url.startsWith(webUrl)) {
              final uri = Uri.parse(request.url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..enableZoom(false)
      ..loadRequest(Uri.parse(webUrl));
  }

  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _downloadFile(String url) async {
    
    final status = await Permission.storage.request();

    if (status.isGranted) {
      try {
        final Directory? downloadsDir = await getExternalStoragePublicDirectory(
            type: ExternalStoragePublicDirectory.downloads);

        if (downloadsDir == null) {
          throw Exception('Could not get downloads directory.');
        }

        final fileName = url.split('/').last.split('?').first;
        final savePath = '${downloadsDir.path}/$fileName';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading $fileName...')),
        );

        final dio = Dio();
        await dio.download(url, savePath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download complete: $fileName')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _controller.reload();
          },
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),

              
              if (_loadingPercentage < 100 && !_hasError)
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        SlideTransition(
                          position: _logoAnimation,
                          child: Image.asset('assets/images/cstloadinglogo1.gif', height: 80),
                        ),
                        const SizedBox(height: 20),

                        

                        
                        Text(
                          'Loading... $_loadingPercentage%',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (_hasError)
              
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cloud_off_rounded,
                            size: 80,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Connection Problem',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _error?.description ??
                                'Please check your internet connection and try again.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _hasError = false;
                              });
                              _controller.reload();
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Directory?> getExternalStoragePublicDirectory(
    {required ExternalStoragePublicDirectory type}) async {
  return getExternalStorageDirectory();
}

enum ExternalStoragePublicDirectory { downloads }