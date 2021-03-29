library activity_log;

import 'dart:async';

import 'package:activity_log/trace_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ActivityLog with ChangeNotifier {
  List<String> activity = [];

  ActivityLog() {
    log('Activity log started', StackTrace.current);
  }

  String get now => DateFormat("Hms").format(DateTime.now());

  void log(String entry, [StackTrace stackTrace]) {
    var traceInfo = TraceParser(stackTrace);
    // print('${traceInfo.fileName}');
    String msg = '[$now] ' + entry;
    activity.add(msg);
    if (traceInfo.fileName != null) {
      msg = '           ${traceInfo.fileName} @ line ${traceInfo.lineNumber}';
      activity.add(msg);
    }
    while (activity.length > 1000) activity.removeAt(0);
    notify();
    // print(entry);
  }

  void notify() {
    // Some times the next frame is a long time in coming.
    Timer t = Timer(Duration(milliseconds: 100), () {
      notifyListeners();
      return;
    });

    // Required to prevent Exception for calling notifyListeners during build.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      t.cancel();
      notifyListeners();
    });
  }
}
