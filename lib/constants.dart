import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:intl/intl.dart';

bool adminLogin = true;

const Color mBlue = Color.fromRGBO(15, 77, 152, 1.0);
const Color mYellow = Color.fromRGBO(253, 200, 10, 1.0);
const Color mSkyBlue = Color.fromRGBO(176, 201, 232, 1.0);
const Color mDarkBlue = Color.fromRGBO(1, 38, 84, 1.0);
//const Color mSkyBlue = Color.fromRGBO(84, 146, 222, 1.0);
//const Color mLightYellow = Color.fromRGBO(255, 249, 230, 1.0);

const Color darkWhite = Color.fromRGBO(205, 205, 205, 1.0);
const Color lineGray = Color.fromRGBO(245, 245, 245, 1.0);



const double text_size_basic = 15;


/// 기기 항목 순서 정렬 (P->N->I->M 순서)
List<Map<String, dynamic>> deviceSort(List<Map<String, dynamic>> list) {
  List<Map<String, dynamic>> result = [];
  list.forEach((element) {
    if (element["no"].contains("P")) {
      result.add(element);
    }
  });
  list.forEach((element) {
    if (element["no"].contains("N")) {
      result.add(element);
    }
  });
  list.forEach((element) {
    if (element["no"].contains("I")) {
      result.add(element);
    }
  });
  list.forEach((element) {
    if (element["no"].contains("M")) {
      result.add(element);
    }
  });
  list.forEach((element) {
    if (element["no"].contains("S")) {
      result.add(element);
    }
  });
  return result;
}

/// 기기종류 return (int)
// ignore: missing_return
int? deviceTypeInt(String pcName) {
  if (pcName.contains("P")) { // 본체
    return 0;
  } else if (pcName.contains("N")) { // 노트북
    return 1;
  } else if (pcName.contains("I")) { // 맥
    return 2;
  } else if (pcName.contains("M")) { // 모니터
    return 3;
  } else if (pcName.contains("S")) { // 서버
    return 4;
  }
}

/// 기기종류 return (int)
// ignore: missing_return
String? deviceTypeString(String pcName) {
  if (pcName.contains("P")) { // 본체
    return "본체($pcName)";
  } else if (pcName.contains("N")) { // 노트북
    return "노트북($pcName)";
  } else if (pcName.contains("I")) { // 맥
    return "맥($pcName)";
  } else if (pcName.contains("M")) { // 모니터
    return "모니터($pcName)";
  } else if (pcName.contains("S")) { // 서버
    return "서버($pcName)";
  }
}

/// 스낵바 표시
showSnackBar(GlobalKey<ScaffoldState> viewKey, String msg) {
  // viewKey.currentState?.removeCurrentSnackBar()
  // final snackBar = new SnackBar(content: new Text(msg), duration: Duration(milliseconds: 1000),);
  // viewKey.currentState?.showSnackBar(snackBar);
}
//
// showSnackBar2(String msg,
//     {Color color = Colors.black12, Color textColor = Colors.black}) {
//
//
//     Widget toast = Container(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30.0),
//         color: color,
//       ),
//       child: Text(msg,
//           style: TextStyle(fontSize: 17, color: textColor)),
//     );
//
//     Fluttertoast.showToast(
//       child: toast,
//       gravity: ToastGravity.BOTTOM,
//       toastDuration: Duration(seconds: 2),
//     );

