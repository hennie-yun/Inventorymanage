import 'package:flutter/material.dart';
import 'package:fluttersmsoftlabpc/allInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'infoPC.dart';
import 'dlgEditPc.dart';

import 'dart:async';
import 'dart:io' show Platform;

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';

import 'Comm/commApi.dart';

/// //////////////////
/// 기기 검색 화면 ///
/// //////////////////
class SearchPC extends StatefulWidget {
  SearchPCState createState() => SearchPCState();
}

class SearchPCState extends State<SearchPC> {
  String pcName = '';
  final pcTextField = TextEditingController();
  GlobalKey<ScaffoldState> viewKey = GlobalKey<ScaffoldState>();
  GlobalKey addKey = GlobalKey();

  ScanResult? scanResult;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.code39);

  double cellHeight = 40.0;
  int pcItemCount = 0;
  int deviceType = 0;
  String pcStatus = '양호';
  TextStyle titleStyle =
      TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold);

  /// User Edit Dialog ///
  String userPC = "";
  String userName = "";
  String userUseDate = "";
  String userReturnDate = "";
  String userEtc = "";

  SharedPreferences? pref;

  bool _switch = false;

  @override
  void initState() {
    pcName = '';
    setPref();
    super.initState();
  }

  Future<void> setPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      if (pref?.getBool('bioLogin') != null) {
        _switch = pref!.getBool('bioLogin')!;
      } else {
        _switch = false;
      }
    });
  }

  // void onClickMenu(PopUpMenuItemProvider item) {
  //   print('Click menu -> ${item.menuTitle}');
  // }

  void onDismiss() {
    print('Menu is dismiss');
  }

  void onShow() {
    print('Menu is show');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: viewKey,
      resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      body: SafeArea(
          child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                      child: Column(
                        children: [
                          /// 상단 로고
                          Center(
                            child: InkWell(
                              onTap: () {
                                if (adminLogin) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AllInfo()));
                                }
                              },
                              child: Image(
                                  image: AssetImage('images/smSoftLabPc.png')),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              '기기 관리 시스템',
                              style: TextStyle(
                                  color: mBlue,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Spacer(),
                  // Column(
                  //   children: [
                  //     /// 스캔 아이콘
                  //     InkWell(
                  //       child: Container(
                  //         alignment: Alignment.center,
                  //         padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  //         child: Icon(Icons.center_focus_weak, size: 150, color: mBlue,),
                  //       ),
                  //       onTap: () {
                  //         scan();
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // Spacer(),
                  /// admin으로 로그인했을 때에만 보여주는 영역
                  Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: adminLogin,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// 기기등록 버튼
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 70,
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: TextButton(
                                  key: addKey,
                                  style: TextButton.styleFrom(
                                    backgroundColor: mBlue, //
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        side: BorderSide(color: mBlue)),
                                  ),
                                  child: Text(
                                    '등록',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {
                                    // listMenu();

                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ShowEditSelectDialog(context);
                                        });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),

                            /// 조회 버튼
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 70,
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: mYellow, //
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        side: BorderSide(color: mYellow)),
                                  ),
                                  child: Text(
                                    '조회',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ShowInquirySelectDialog(context);
                                        });
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                  Spacer()
                ],
              ))),
    );
  }

  /// 기기 상세정보 표시 화면으로 이동
  void moveInfo() {
    FocusScope.of(context).unfocus();
    // viewKey.currentState?.removeCurrentSnackBar();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    if (pcName != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => InfoPC(pcName)));
    }
    // Navigator.push(context, MaterialPageRoute(builder: (context) => InfoPC(pcName)));
    pcTextField.text = '';
  }

  /// QR코드 스캔
  Future scan() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": '취소',
          "flash_on": 'ON',
          "flash_off": 'OFF',
        },
        restrictFormat: [..._possibleFormats],
        useCamera: -1,
        autoEnableFlash: false,
        android: AndroidOptions(
          aspectTolerance: 0.00,
          useAutoFocus: false,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);

      setState(() {
        scanResult = result;
        if (scanResult?.rawContent.trim() != "") {
          pcTextField.text = scanResult!.rawContent;
          pcName = pcTextField.text;
          FocusScope.of(context).unfocus();
          if (pcName.trim() != "" && pcTextField.text != "") {
            getMachineInfo(pcName.trim())
                .then((List<Map<String, dynamic>> data) {
              // 기기정보 통신 요청
              if (data.length > 0) {
                // 통신성공
                List<Map<String, dynamic>> pcData = data[0]['pcData'];
                if (pcData.isEmpty) {
                  // 데이터 없을 때
                  showSnackBar(viewKey, "기기가 없습니다.");
                } else {
                  // 데이터 있을 때
                  moveInfo();
                }
              } else {
                // 통신실패
                showSnackBar(viewKey, "데이터를 가져올 수 없습니다.");
              }
            });
          } else {
            // QR코드 스캔시 데이터가 없을때...?
            showSnackBar(viewKey, "기기를 입력해주세요.");
          }
        }
      });
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          // result.rawContent = 'The user did not grant the camera permission!';
        });
      } else {
        // result.rawContent = 'Unknown error: $e';
      }
      setState(() {
        scanResult = result;
        pcTextField.text = scanResult!.rawContent;
        pcName = pcTextField.text;
      });
    }
  }



  /// 사용자 등록 다이얼로그
  Dialog ShowUserEditDialog(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 58,
                child: Container(
                    color: mSkyBlue,
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            '사용자 등록',
                            style: TextStyle(
                                fontSize: 17,
                                color: mDarkBlue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 25,
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (userName != null &&
                                userName != "" &&
                                userPC != null &&
                                userPC != "") {
                              postSetUser(userPC, userName, userUseDate,
                                      userReturnDate, userEtc)
                                  .then((bool value) {
                                if (value) {
                                  print('[추가] postSetUser : $value');
                                  showSnackBar(viewKey, "저장 완료");
                                  setState(() {});
                                  // viewKey.currentState?.removeCurrentSnackBar();
                                  ScaffoldMessenger.of(context)
                                      .removeCurrentSnackBar();
                                } else {
                                  showSnackBar(viewKey, "저장 실패");
                                }
                              });
                            } else {
                              showSnackBar(
                                  viewKey, "기기 번호와 사용자 이름은 필수 입력사항입니다.");
                            }
                            Navigator.pop(context);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 25,
                          ),
                          onPressed: () {
                            // viewKey.currentState?.removeCurrentSnackBar();
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )),
              ),
              Expanded(
                child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      height: (cellHeight * 5) + (0.5 * 4 * 2) + 12,
                      child: Container(
                        color: mDarkBlue,
                        padding: EdgeInsets.all(0.5),
                        child: Column(
                          children: [
                            _userInfoEdit('기기번호', 0),
                            _userInfoEdit('사용자', 1),
                            _userInfoEdit('사용일자', 2),
                            _userInfoEdit('반납일자', 3),
                            _userInfoEdit('비고', 4),
                          ],
                        ),
                      ),
                    )),
              )
            ],
          )),
    );
  }

  /// 사용자 등록 다이얼로그 텍스트필드
  Container _userInfoEdit(String titleStr, int type) {
    final textField = TextEditingController();

    return Container(
      child: Container(
          color: mDarkBlue,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: cellHeight,
                  margin: EdgeInsets.all(0.5),
                  alignment: Alignment.center,
                  color: mYellow,
                  child: Text(titleStr, style: titleStyle),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  height: cellHeight,
                  margin: EdgeInsets.all(0.5),
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: textField,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: mDarkBlue,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: mDarkBlue,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          )),
                      onChanged: (data) {
                        setState(() {
                          switch (type) {
                            case 0:
                              userPC = data;
                              break;
                            case 1:
                              userName = data;
                              break;
                            case 2:
                              userUseDate = data;
                              break;
                            case 3:
                              userReturnDate = data;
                              break;
                            case 4:
                              userEtc = data;
                              break;
                          }
                        });
                      },
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  /// 자동로그인 해제 경고 다이얼로그
  Dialog ShowLoginWarningDialog(BuildContext context, bool value) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 170,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 2, 0, 2),
              color: mBlue,
              height: 40,
              child: Row(
                children: <Widget>[
                  Text(
                    '생체인증 해제 경고',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
                    child: Column(
              children: [
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 90,
                    child: Text(
                      '생체인증 로그인 해제 시 기존 로그인 정보가 삭제됩니다.',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Spacer(),
                    Spacer(),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                        height: 40,
                        child: Text(
                          '취소',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                        height: 40,
                        child: Text(
                          '확인',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                        // 로그인 정보 지우기
                        pref?.setBool('bioLogin', _switch);
                        pref?.setString('id', "");
                        pref?.setString('pw', "");
                        setState(() {
                          _switch = value;
                        });
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ],
            )))
          ],
        ),
      ),
    );
  }

//조회 선택
  Container ShowInquirySelectDialog(BuildContext context) {
    return  Container(
        color: Colors.white,
        child :
        Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 550,
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
                            '기기 리스트 보기',
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
                          child: Text('조회 할 리스트를 선택 해 주세요 ',
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

                            },
                          ),
                        ],
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
                                '전체 조회',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);

                              deviceType = 6;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllInfo()));
                            },
                          ),

                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
