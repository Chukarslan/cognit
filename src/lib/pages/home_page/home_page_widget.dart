import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import '/custom_code/actions/index.dart' as actions;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    animationsMap.addAll({
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'imageOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.1, 1.1),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF131313),
        body: Stack(
          children: [
            Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_model.showWaveform)
                        Lottie.asset(
                          'assets/lottie_animations/Audio_Wave.json',
                          width: 400.0,
                          height: 200.0,
                          fit: BoxFit.fill,
                          animate: true,
                        ),
                      if (_model.showWaveform)
                        FlutterFlowTimer(
                          initialTime: valueOrDefault<int>(
                            FFAppState().timerValue,
                            1000,
                          ),
                          getDisplayTime: (value) =>
                              StopWatchTimer.getDisplayTime(
                            value,
                            hours: false,
                            minute: false,
                            milliSecond: false,
                          ),
                          controller: _model.timerController,
                          updateStateInterval: const Duration(milliseconds: 1000),
                          onChanged: (value, displayTime, shouldUpdate) {
                            _model.timerMilliseconds = value;
                            _model.timerValue = displayTime;
                            if (shouldUpdate) setState(() {});
                          },
                          onEnded: () async {
                            _model.timerController.onResetTimer();

                            _model.showWaveform = false;
                            setState(() {});
                          },
                          textAlign: TextAlign.start,
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Outfit',
                                color: const Color(0x00FFFFFF),
                                fontSize: 2.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      if (!_model.showWaveform)
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!_model.isRecording)
                                FlutterFlowIconButton(
                                  borderRadius: 100.0,
                                  buttonSize: 150.0,
                                  fillColor: const Color(0xFF131313),
                                  icon: Icon(
                                    Icons.mic_rounded,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: 60.0,
                                  ),
                                  showLoadingIndicator: true,
                                  onPressed: () async {
                                    unawaited(
                                      () async {
                                        await actions.startTextRecording();
                                      }(),
                                    );
                                    _model.isRecording = true;
                                    setState(() {});
                                  },
                                ),
                              if (_model.isRecording)
                                FlutterFlowIconButton(
                                  borderRadius: 100.0,
                                  buttonSize: 150.0,
                                  fillColor: const Color(0xFF131313),
                                  icon: Icon(
                                    Icons.stop_rounded,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: 60.0,
                                  ),
                                  showLoadingIndicator: true,
                                  onPressed: () async {
                                    _model.isRecording = false;
                                    setState(() {});
                                    await actions.stopTextRecording();
                                    _model.getResponseAPICall =
                                        await GetResponseCall.call();

                                    if ((_model.getResponseAPICall?.succeeded ??
                                        true)) {
                                      _model.speechOutput =
                                          await actions.fetchSpeechAndPlay(
                                        getJsonField(
                                          (_model.getResponseAPICall
                                                  ?.jsonBody ??
                                              ''),
                                          r'''$.choices[:].message.content''',
                                        ).toString(),
                                        FFAppState().apiKey,
                                      );
                                      FFAppState().timerValue =
                                          _model.speechOutput!;
                                      FFAppState().speechToTextResponse = '';
                                      setState(() {});
                                      _model.showWaveform = true;
                                      setState(() {});
                                      await Future.delayed(
                                          const Duration(milliseconds: 100));
                                      _model.timerController.onStartTimer();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Failed',
                                            style: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          ),
                                          duration:
                                              const Duration(milliseconds: 4000),
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                        ),
                                      );
                                    }

                                    setState(() {});
                                  },
                                ),
                            ],
                          ).animateOnPageLoad(
                              animationsMap['columnOnPageLoadAnimation']!),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0.0, 1.0),
              child: Container(
                width: double.infinity,
                height: 40.0,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                ),
                child: Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          'qtxe7kmv' /* © Cognit demonstator. All Righ... */,
                        ),
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0.0, -1.0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                child: MouseRegion(
                  opaque: false,
                  cursor: MouseCursor.defer ?? MouseCursor.defer,
                  onEnter: ((event) async {
                    setState(() => _model.mouseRegionHovered = true);
                    if (animationsMap['imageOnActionTriggerAnimation'] !=
                        null) {
                      await animationsMap['imageOnActionTriggerAnimation']!
                          .controller
                          .forward(from: 0.0);
                    }
                  }),
                  onExit: ((event) async {
                    setState(() => _model.mouseRegionHovered = false);
                    if (animationsMap['imageOnActionTriggerAnimation'] !=
                        null) {
                      await animationsMap['imageOnActionTriggerAnimation']!
                          .controller
                          .reverse();
                    }
                  }),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        await launchURL('https://app.flutterflow.io/');
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/images/cognit.JPG',
                          width: 77.0,
                          height: 66.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ).animateOnActionTrigger(
                      animationsMap['imageOnActionTriggerAnimation']!,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
