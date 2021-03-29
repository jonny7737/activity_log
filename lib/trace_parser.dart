class TraceParser {
  final StackTrace _trace;

  String fileName;
  int lineNumber;
  int columnNumber;

  TraceParser(this._trace) {
    if (_trace == null) return;
    _parseTrace();
  }

  void _parseTrace() {
    /* The trace comes with multiple lines of strings, we just want the first line,
    *   which has the information we need
    */
    var traceString = this._trace.toString().split("\n")[0];

    /* Search through the string and find the index of the file name by looking for the '.dart' regex */
    var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_]+.dart'));

    var fileInfo = traceString.substring(indexOfFileName);

    var listOfInfos = fileInfo.split(RegExp(r"([:)])"));

    /* Splitting fileInfo by the character ":" separates the file name,
      the line number and the column counter nicely.
      Example: main.dart:5:12
      To get the file name, we split with ":" and get the first index
      To get the line number, we would have to get the second index
      To get the column number, we would have to get the third index
    */

    this.fileName = listOfInfos[0];
    this.lineNumber = int.parse(listOfInfos[1]);
    var columnStr = listOfInfos[2];
    if (columnStr.trim().length > 0)
      this.columnNumber = int.parse(columnStr);
    else
      this.columnNumber = -1;
  }
}
