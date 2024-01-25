
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

import 'dlgEditPc.dart';


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

int pcItemCount = 0;
int deviceType = 0;


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

void showAnimatedSnackBar(BuildContext context, String titlemsg, String msg, String type) {
  AnimatedSnackBar.rectangle(
    titlemsg,
    msg,
    type: _getSnackBarType(type),
    duration : const Duration(seconds: 5),
  ).show(context);
}

AnimatedSnackBarType _getSnackBarType(String type) {
  switch (type) {
    case 'info':
      return AnimatedSnackBarType.info;
    case 'success':
      return AnimatedSnackBarType.success;
    case 'warning':
      return AnimatedSnackBarType.warning;
    case 'error':
      return AnimatedSnackBarType.error;
    default:
      return AnimatedSnackBarType.info;
  }
}


/// 스낵바 표시
showSnackBar(GlobalKey<ScaffoldState> viewKey, String msg) {
  // viewKey.currentState?.removeCurrentSnackBar()
  // final snackBar = new SnackBar(content: new Text(msg), duration: Duration(milliseconds: 1000),);
  // viewKey.currentState?.showSnackBar(snackBar);
}

/// 기기등록 선택 다이얼로그
Container ShowEditSelectDialog(BuildContext context) {
  return  Container(
      color: Colors.white,
      child :
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 500,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10, 2, 0, 2),
                color: mBlue,
                height: 50,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '기기 선택',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 25,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        child: Text('등록할 기기를 선택해 주세요',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black45,
                                fontWeight: FontWeight.w800))),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Container(
                              height: 90,
                              width: 90,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: mYellow,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    spreadRadius: 0,
                                    blurRadius: 4.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Text(
                                '본체',
                                style:
                                TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);

                              deviceType = 0;
                              moveEditDialog(context,GlobalKey<ScaffoldState>());
                            },
                          ),
                          InkWell(
                            child: Container(
                              height: 90,
                              width: 90,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: mYellow,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    spreadRadius: 0,
                                    blurRadius: 4.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Text(
                                '노트북',
                                style:
                                TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);

                              deviceType = 1;
                              moveEditDialog(context,GlobalKey<ScaffoldState>());
                            },
                          ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Container(
                              height: 90,
                              width: 90,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: mYellow,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    spreadRadius: 0,
                                    blurRadius: 4.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Text(
                                '맥',
                                style:
                                TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);

                              deviceType = 2;
                              moveEditDialog(context,GlobalKey<ScaffoldState>());
                            },
                          ),
                          InkWell(
                            child: Container(
                              height: 90,
                              width: 90,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: mYellow,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    spreadRadius: 0,
                                    blurRadius: 4.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Text(
                                '모니터',
                                style:
                                TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);

                              deviceType = 3;
                              moveEditDialog(context,GlobalKey<ScaffoldState>());
                            },
                          ),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Container(
                            height: 90,
                            width: 90,
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: mYellow,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  spreadRadius: 0,
                                  blurRadius: 4.0,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Text(
                              '서버',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);

                            deviceType = 4;
                            moveEditDialog(context, GlobalKey<ScaffoldState>() );
                          },
                        ),
                        InkWell(
                          child: Container(
                            height: 90,
                            width: 90,
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: mYellow,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  spreadRadius: 0,
                                  blurRadius: 4.0,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Text(
                              '기타',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);

                            deviceType = 5;
                            moveEditDialog(context,GlobalKey<ScaffoldState>());
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ));
}

/// 기기등록 다이얼로그 표시
void moveEditDialog(BuildContext context, GlobalKey<ScaffoldState> viewKey) {
  switch (deviceType) {
    case 0: // P
      pcItemCount = 16;
      break;
    case 1: // N
      pcItemCount = 17;
      break;
    case 2: // I
      pcItemCount = 17;
      break;
    case 3: // M
      pcItemCount = 7;
      break;
    case 4: // M
      pcItemCount = 7;
      break;
  }

  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: new DlgEditPc(
              viewKey: viewKey,
              pcEditItem: Map(),
              pcItemCount: pcItemCount,
              deviceType: deviceType,
              deviceAdd: true),
        );
      });
}

