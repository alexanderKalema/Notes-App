import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../constants/sizes.dart';
import 'loading_screen_controller.dart';

class LoadingScreen {
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();

  LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  void show({
    required BuildContext context,
    required String text,
    required Color color,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      print("am being showed");
      controller = showOverlay(
        context: context,
        text: text,
        color: color,
      );
    }
  }

  void hide() {
    print("am being closed");
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
    required Color color,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
                constraints: BoxConstraints(
                  maxWidth: Sizes.getTotalWidth(context) * 0.8,
                  maxHeight: Sizes.getTotalHeight(context) * 0.8,
                  minWidth: Sizes.getTotalWidth(context) * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        SpinKitPouringHourGlassRefined(
                          color: color,
                          size: 90.0,
                        ),
                        const SizedBox(height: 20),
                        StreamBuilder(
                          stream: _text.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data as String,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF3f5368),
                                    fontSize: 19,
                                    fontWeight: FontWeight.w200,
                                    fontFamily: "PoppinsSemiBold"),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        );
      },
    );

    state?.insert(overlay);

    return LoadingScreenController(
      close: () {
        _text.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        _text.add(text);
        return true;
      },
    );
  }
}
