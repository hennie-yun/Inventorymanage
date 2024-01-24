import 'package:flutter/material.dart';
import 'package:fluttersmsoftlabpc/allInfo.dart';
import 'constants.dart';

import 'Comm/commApi.dart';
import 'package:intl/intl.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';

/// //////////////////////////////
/// 기기편집 다이얼로그 클래스 ///
/// //////////////////////////////
class DlgEditPc extends StatefulWidget {
  final GlobalKey<ScaffoldState>? viewKey;
  String? title = "";
  final Map<String, dynamic>? pcEditItem;
  int? pcItemCount;
  final int? deviceType;
  final bool? deviceAdd;

  DlgEditPc(
      {Key? key,
      this.viewKey,
      this.title,
      this.pcEditItem,
      this.pcItemCount,
      this.deviceType,
      this.deviceAdd})
      : super(key: key);

  @override
  State createState() => new DlgEditPcState();
}

class DlgEditPcState extends State<DlgEditPc> {
  double cellHeight = 40.0;
  double cellHeight1 = 45.0;
  double cellHeight2 = 80.0;
  int bigCount = 7;
  TextStyle titleStyle =
      TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold);
  String pcStatus = '양호';

  int ssdCount = 3;
  int hddCount = 3;

  Map<String, dynamic>? pcEditItemCopy;
  Map<String, dynamic>? pcEditItemCopy2;

  @override
  void initState() {
    print('initState() 호출됨');
    super.initState();
    pcEditItemCopy = widget.pcEditItem;
    pcEditItemCopy2 = pcEditItemCopy;

    if (widget.pcEditItem!.isNotEmpty) {
      pcStatus = widget.pcEditItem?['status'];
    }
    if (widget.deviceAdd!) {
      // 기기등록 일 때
      ssdCount = 3;
      hddCount = 3;
      if (widget.deviceType == 0) {
        widget.title = "PC 등록";
        widget.pcEditItem?['no'] = "P-";
        widget.pcEditItem?['m_type'] = "PC";
      } else if (widget.deviceType == 1) {
        widget.title = "노트북 등록";
        bigCount += 1;
        widget.pcEditItem?['no'] = "N-";
        widget.pcEditItem?['m_type'] = "노트북";
      } else if (widget.deviceType == 2) {
        widget.title = "맥 등록";
        widget.pcEditItem?['no'] = "I-";
        widget.pcEditItem?['m_type'] = "맥";
      } else if (widget.deviceType == 3) {
        widget.title = "모니터 등록";
        bigCount = 0;
        ssdCount = 0;
        hddCount = 0;
        widget.pcEditItem?['no'] = "M-";
        widget.pcEditItem?['m_type'] = "모니터";
      } else if (widget.deviceType == 4) {
        widget.title = "서버 등록";
        widget.pcEditItem?['no'] = "S-";
        widget.pcEditItem?['m_type'] = "서버";
      } else if (widget.deviceType == 5) {
        widget.title = "기타 기기 등록";
        widget.pcEditItem?['no'] = "NEW-";
        widget.pcEditItem?['m_type'] = "기타";
      }

      widget.pcItemCount = widget.pcItemCount! + 1;
    } else {
      // 기기편집 일 때
      widget.title = widget.title! + " 편집";

      if (widget.deviceType == 1) {
        bigCount += 1;
      }

      // SSD, HDD 아이템 카운트
      ssdCount = 3;
      if (widget.pcEditItem?['ssd1'].toString() == "") {
        bigCount -= 1;
        ssdCount -= 1;
      }
      if (widget.pcEditItem?['ssd2'].toString() == "") {
        bigCount -= 1;
        ssdCount -= 1;
      }
      if (widget.pcEditItem?['ssd3'].toString() == "") {
        bigCount -= 1;
        ssdCount -= 1;
      }
      hddCount = 3;
      if (widget.pcEditItem?['hdd1'].toString() == "") {
        bigCount -= 1;
        hddCount -= 1;
      }
      if (widget.pcEditItem?['hdd2'].toString() == "") {
        bigCount -= 1;
        hddCount -= 1;
      }
      if (widget.pcEditItem?['hdd3'].toString() == "") {
        bigCount -= 1;
        hddCount -= 1;
      }

      if (widget.deviceType == 3) {
        bigCount -= 1;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies() 호출됨');
    // pcEditItemCopy = widget.pcEditItem;
  }

  @override
  void deactivate() {
    print('deactivate() 호출됨');
    super.deactivate();
    // getAssetList(true);
  }

  @override
  void dispose() {
    print('dispose() 호출됨');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceheight = MediaQuery.of(context).size.height;

    return Dialog(
        insetPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Container(
            width: deviceWidth * 0.9,
            height: deviceheight * 0.7,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  width: deviceWidth * 0.9,
                  height: 58,
                  color: mBlue,
                  // padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Align(
                    child: Text(widget.title!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 20, 15, 5),
                          // height: (cellHeight1*(widget.pcItemCount!-bigCount))+(cellHeight2*bigCount)+(0.5*(widget.pcItemCount!)*2)+16,
                          child: Container(
                              padding: EdgeInsets.all(0.5),
                              child: Column(
                                children: [
                                  EditView(context),
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text('*는 필수 입력 사항입니다',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.red,
                                                fontStyle: FontStyle.italic))),
                                  ),
                                ],
                              )),
                        ))),

                //취소 및 등록 버튼
                Container(
                    padding: EdgeInsets.fromLTRB(15, 20, 15, 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 70,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: mYellow,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    side: BorderSide(color: mYellow)),
                              ),
                              child: Text(
                                '취소',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.pop(context, false);
                                setState(() {
                                  AllInfoState();
                                });

                              },

                            ),

                          ),

                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 70,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: mBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
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
                                FocusScope.of(context).unfocus();
                                if (widget.deviceAdd!) {
                                  if ((widget.pcEditItem?["no"] != null &&
                                          widget.pcEditItem?["no"].toString() !=
                                              "") &&
                                      (widget.pcEditItem?["m_type"] != null &&
                                          widget.pcEditItem?["m_type"]
                                                  .toString() !=
                                              "") &&
                                      (widget.pcEditItem?["m_model"] != null &&
                                          widget.pcEditItem?["m_model"]
                                                  .toString() !=
                                              "") &&
                                      (widget.pcEditItem?["m_user"] != null &&
                                          widget.pcEditItem?["m_user"]
                                                  .toString() !=
                                              "")) {
                                    postAddAsset(
                                            widget.pcEditItem!["no"]
                                                .toString()
                                                .toUpperCase(),
                                            //필수
                                            widget.pcEditItem!["m_type"],
                                            //필수
                                            widget.pcEditItem!["m_model"],
                                            //필수
                                            widget.pcEditItem!["m_os"] ?? "",
                                            widget.pcEditItem!["m_user"],
                                            //필수
                                            widget.pcEditItem![
                                                    "purchase_date"] ??
                                                "",
                                            widget.pcEditItem!["m_place"] ?? "",
                                            widget.pcEditItem!["etc"] ?? "")
                                        .then((bool value) {
                                      if (value) {
                                        if (widget.deviceAdd!) {
                                          print('[추가] postSetMachine : $value');
                                        } else {
                                          print('[편집] postSetMachine : $value');
                                        }
                                        IconSnackBar.show(
                                            context: context,
                                            label: "저장 완료",
                                            snackBarType: SnackBarType.save);
                                        Navigator.pop(context, true);
                                      } else {
                                        IconSnackBar.show(
                                            context: context,
                                            label: "저장 실패",
                                            snackBarType: SnackBarType.fail);
                                        Navigator.pop(context, false);
                                      }
                                    });
                                  } else {
                                    if (widget.pcEditItem?["no"] != null &&
                                        widget.pcEditItem?["no"].toString() !=
                                            "") {
                                      IconSnackBar.show(
                                          context: context,
                                          label: "기기번호는 필수 입력사항 입니다.",
                                          snackBarType: SnackBarType.alert);
                                    } else if (widget.pcEditItem?["m_type"] !=
                                            null &&
                                        widget.pcEditItem?["m_type"]
                                                .toString() !=
                                            "") {
                                      IconSnackBar.show(
                                          context: context,
                                          label: "종류는 필수 입력사항 입니다.",
                                          snackBarType: SnackBarType.alert);
                                    } else if (widget.pcEditItem?["m_model"] !=
                                            null &&
                                        widget.pcEditItem?["m_model"]
                                                .toString() !=
                                            "") {
                                      IconSnackBar.show(
                                          context: context,
                                          label: "사양은 필수 입력사항 입니다.",
                                          snackBarType: SnackBarType.alert);
                                    } else if (widget.pcEditItem?["m_user"] !=
                                            null &&
                                        widget.pcEditItem?["m_user"]
                                                .toString() !=
                                            "") {
                                      IconSnackBar.show(
                                          context: context,
                                          label: "사용자명은 필수 입력사항 입니다.",
                                          snackBarType: SnackBarType.alert);
                                    } else {
                                      IconSnackBar.show(
                                          context: context,
                                          label: "저장 실패",
                                          snackBarType: SnackBarType.fail);
                                    }
                                    // Navigator.pop(context, false);
                                  }
                                } else {
                                  // 편집
                                  if ((widget.pcEditItem?["no"] != null &&
                                          widget.pcEditItem?["no"].toString() !=
                                              "") &&
                                      (widget.pcEditItem?["m_type"] != null &&
                                          widget.pcEditItem?["m_type"].toString() !=
                                              "") &&
                                      (widget.pcEditItem?["m_model"] != null &&
                                          widget.pcEditItem?["m_model"].toString() !=
                                              "") &&
                                      (widget.pcEditItem?["m_os"] != null &&
                                          widget.pcEditItem?["m_os"].toString() !=
                                              "") &&
                                      (widget.pcEditItem?["m_user"] != null &&
                                          widget.pcEditItem?["m_user"].toString() !=
                                              "") &&
                                      (widget.pcEditItem?["purchase_date"] != null &&
                                          widget.pcEditItem?["purchase_date"]
                                                  .toString() !=
                                              "") &&
                                      (widget.pcEditItem?["m_place"] != null &&
                                          widget.pcEditItem?["m_place"].toString() !=
                                              "") &&
                                      (widget.pcEditItem?["etc"] != null &&
                                          widget.pcEditItem?["etc"].toString() !=
                                              "") &&
                                      (widget.pcEditItem?["status"] != null &&
                                          widget.pcEditItem?["status"].toString() != "")) {
                                    postUpdateAsset(
                                            widget.pcEditItem!["no"]
                                                .toString()
                                                .toUpperCase(),
                                            widget.pcEditItem!["m_type"],
                                            widget.pcEditItem!["m_model"],
                                            widget.pcEditItem!["m_os"],
                                            widget.pcEditItem!["m_user"],
                                            widget.pcEditItem!["purchase_date"],
                                            widget.pcEditItem!["m_place"],
                                            widget.pcEditItem!["etc"],
                                            widget.pcEditItem!["status"])
                                        .then((bool value) {
                                      if (value) {
                                        if (widget.deviceAdd!) {
                                          print('[추가] postSetMachine : $value');
                                        } else {
                                          print('[편집] postSetMachine : $value');
                                        }
                                        IconSnackBar.show(
                                            context: context,
                                            label: "저장 완료",
                                            snackBarType: SnackBarType.save);
                                        getAssetList(true);
                                        Navigator.pop(context, true);
                                      } else {
                                        IconSnackBar.show(
                                            context: context,
                                            label: "저장 실패",
                                            snackBarType: SnackBarType.fail);
                                        Navigator.pop(context, false);
                                      }
                                    });
                                  } else {
                                    IconSnackBar.show(
                                        context: context,
                                        label: "모든 입력사항은 필수입니다.",
                                        snackBarType: SnackBarType.alert);
                                    // Navigator.pop(context, false);
                                  }
                                }
                                // Navigator.pop(context, true);
                              },
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            )));
  }

  Column EditView(BuildContext context) {
    if (widget.deviceAdd!) {
      return Column(
        children: [
          if (widget.deviceAdd!) _detailInfoEdit('기기번호', 'no'),
          _detailInfoEdit('종류', 'm_type'),
          _detailInfoEdit('사양', 'm_model'),
          _detailInfoEdit('OS', 'm_os'),
          _detailInfoEdit('사용자명', 'm_user'),
          // _detailInfoEditStatus('상태', pcStatus),
          _detailInfoEdit('구입일자', 'purchase_date'),
          _detailInfoEdit('사용장소', 'm_place'),
          _detailInfoEdit('비고', 'etc'),
        ],
      );
    } else {
      return Column(
        children: [
          _detailInfoEdit('기기번호', 'no'),
          _detailInfoEdit('종류', 'm_type'),
          _detailInfoEdit('사양', 'm_model'),
          _detailInfoEdit('OS', 'm_os'),
          _detailInfoEdit('사용자명', 'm_user'),
          _detailInfoEditStatus('상태', pcStatus),
          _detailInfoEdit('구입일자', 'purchase_date'),
          _detailInfoEdit('사용장소', 'm_place'),
          _detailInfoEdit('비고', 'etc'),
        ],
      );
    }

    // if(widget.deviceType == 0){
    //   return Column(
    //     children: [
    //       if (widget.deviceAdd!) _detailInfoEdit('기기번호', 'no'),
    //       _detailInfoEdit('종류', 'm_type'),
    //       _detailInfoEdit('사양', 'm_model'),
    //       _detailInfoEdit('OS', 'm_os'),
    //       _detailInfoEdit('사용자명', 'm_user'),
    //       // _detailInfoEditStatus('상태', pcStatus),
    //       _detailInfoEdit('구입일자', 'purchase_date'),
    //       _detailInfoEdit('사용장소', 'm_place'),
    //       _detailInfoEdit('비고', 'etc'),
    //     ],
    //   );
    // } else if(widget.deviceType == 1 || widget.deviceType == 2) {
    //   return Column(
    //     children: [
    //       if (widget.deviceAdd!) _detailInfoEdit('기기번호', 'no'),
    //       _detailInfoEdit('종류', 'm_type'),
    //       _detailInfoEdit('사양', 'm_model'),
    //       _detailInfoEdit('OS', 'm_os'),
    //       _detailInfoEdit('사용자명', 'm_user'),
    //       // _detailInfoEditStatus('상태', pcStatus),
    //       _detailInfoEdit('구입일자', 'purchase_date'),
    //       _detailInfoEdit('사용장소', 'm_place'),
    //       _detailInfoEdit('비고', 'etc'),
    //       // _detailInfoEdit('모델명', 'model'),
    //       // _detailInfoEdit('CPU', 'cpu'),
    //       // if (ssdCount > 0) _detailInfoEdit('SSD1', 'ssd1'),
    //       // if (ssdCount > 1) _detailInfoEdit('SSD2', 'ssd2'),
    //       // if (ssdCount > 2) _detailInfoEdit('SSD3', 'ssd3'),
    //       // if (hddCount > 0) _detailInfoEdit('HDD1', 'hdd1'),
    //       // if (hddCount > 1) _detailInfoEdit('HDD2', 'hdd2'),
    //       // if (hddCount > 2) _detailInfoEdit('HDD3', 'hdd3'),
    //       // _detailInfoEdit('메모리', 'mem'),
    //       // _detailInfoEdit('OS', 'os'),
    //       // _detailInfoEdit('VGA', 'vga'),
    //       // // _detailInfoEditStatus('상태', pcStatus),
    //       // _detailInfoEdit('구입가', 'price'),
    //       // _detailInfoEdit('위치', 'location'),
    //       // _detailInfoEdit('입고일', 'fromdate'),
    //       // _detailInfoEdit('수정일', 'updatedate'),
    //       // _detailInfoEdit('비고', 'etc'),
    //     ],
    //   );
    // } else if(widget.deviceType == 3){
    //   return Column(
    //     children: [
    //       if (widget.deviceAdd!) _detailInfoEdit('기기번호', 'no'),
    //       _detailInfoEdit('종류', 'm_type'),
    //       _detailInfoEdit('사양', 'm_model'),
    //       _detailInfoEdit('OS', 'm_os'),
    //       _detailInfoEdit('사용자명', 'm_user'),
    //       // _detailInfoEditStatus('상태', pcStatus),
    //       _detailInfoEdit('구입일자', 'purchase_date'),
    //       _detailInfoEdit('사용장소', 'm_place'),
    //       _detailInfoEdit('비고', 'etc'),
    //       // _detailInfoEdit('모델명', 'model'),
    //       // _detailInfoEditStatus('상태', pcStatus),
    //       // _detailInfoEdit('구입가', 'price'),
    //       // _detailInfoEdit('위치', 'location'),
    //       // _detailInfoEdit('입고일', 'fromdate'),
    //       // _detailInfoEdit('수정일', 'updatedate'),
    //       // _detailInfoEdit('비고', 'etc'),
    //     ],
    //   );
    // } else {
    //   return Column(
    //     children: [
    //       if (widget.deviceAdd!) _detailInfoEdit('기기번호', 'no'),
    //       _detailInfoEdit('종류', 'm_type'),
    //       _detailInfoEdit('사양', 'm_model'),
    //       _detailInfoEdit('OS', 'm_os'),
    //       _detailInfoEdit('사용자명', 'm_user'),
    //       // _detailInfoEditStatus('상태', pcStatus),
    //       _detailInfoEdit('구입일자', 'purchase_date'),
    //       _detailInfoEdit('사용장소', 'm_place'),
    //       _detailInfoEdit('비고', 'etc'),
    //       // _detailInfoEdit('모델명', 'model'),
    //       // _detailInfoEdit('CPU', 'cpu'),
    //       // if (ssdCount > 0) _detailInfoEdit('SSD1', 'ssd1'),
    //       // if (ssdCount > 1) _detailInfoEdit('SSD2', 'ssd2'),
    //       // if (ssdCount > 2) _detailInfoEdit('SSD3', 'ssd3'),
    //       // if (hddCount > 0) _detailInfoEdit('HDD1', 'hdd1'),
    //       // if (hddCount > 1) _detailInfoEdit('HDD2', 'hdd2'),
    //       // if (hddCount > 2) _detailInfoEdit('HDD3', 'hdd3'),
    //       // _detailInfoEdit('메모리', 'mem'),
    //       // _detailInfoEdit('OS', 'os'),
    //       // _detailInfoEdit('VGA', 'vga'),
    //       // _detailInfoEditStatus('상태', pcStatus),
    //       // _detailInfoEdit('구입가', 'price'),
    //       // _detailInfoEdit('위치', 'location'),
    //       // _detailInfoEdit('입고일', 'fromdate'),
    //       // _detailInfoEdit('수정일', 'updatedate'),
    //       // _detailInfoEdit('비고', 'etc'),
    //     ],
    //   );
    // }
  }

  /// 텍스트필드
  Container _detailInfoEdit(String titleStr, String valueStr) {
    final textField = TextEditingController();

    if (widget.pcEditItem?[valueStr].toString() != 'null') {
      textField.text = widget.pcEditItem![valueStr].toString();
    }

    // if(titleStr == '종류'){
    //   if(widget.deviceType == 0) {
    //     widget.pcEditItem![valueStr] = 'PC';
    //   } else if(widget.deviceType == 1) {
    //     widget.pcEditItem![valueStr] = '노트북';
    //   } else if(widget.deviceType == 2) {
    //     widget.pcEditItem![valueStr] = '맥';
    //   } else if(widget.deviceType == 3) {
    //     widget.pcEditItem![valueStr] = '모니터';
    //   }
    // }

    if (titleStr == '사양') {
      cellHeight = cellHeight2;
    } else {
      cellHeight = cellHeight1;
    }

    if (widget.deviceType == 1 && titleStr == '모델명') {
      cellHeight = cellHeight2;
    }

    if (valueStr == 'updatedate') {
      // 시스템 날짜 가져와서 설정해주기
      DateTime date = DateTime.now();
      String formattedDate = DateFormat('yyyyMMdd').format(date);
      textField.text = formattedDate;
      widget.pcEditItem?[valueStr] = formattedDate;
    }

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(titleStr, style: titleStyle),
                    if (widget.deviceAdd! &&
                        (titleStr == '기기번호' ||
                            titleStr == '종류' ||
                            titleStr == '사양' ||
                            titleStr == '사용자명'))
                      Text('*',
                          style: TextStyle(fontSize: 12, color: Colors.red)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                height: cellHeight,
                margin: EdgeInsets.all(0.5),
                alignment: Alignment.center,
                color: Colors.white,
                child: titleStr == '종류'
                    ? Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.pcEditItem?["m_type"] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: cellHeight,
                        child: TextFormField(
                          maxLines: 5,
                          controller: textField,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(
                                10, cellHeight / 5, 10, cellHeight / 5),
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black),
                            border: InputBorder.none,
                          ),
                          onChanged: (data) {
                            widget.pcEditItem?[valueStr] = data;
                          },
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 기기 상태 선택 필드
  Container _detailInfoEditStatus(String titleStr, String valueStr) {
    return Container(
      child: Container(
          color: mDarkBlue,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: cellHeight1,
                  margin: EdgeInsets.all(0.5),
                  alignment: Alignment.center,
                  color: mYellow,
                  child: Text(titleStr, style: titleStyle),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                    height: cellHeight1,
                    margin: EdgeInsets.all(0.5),
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: InkWell(
                      child: Container(
                          height: cellHeight1,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(valueStr, style: titleStyle),
                                ),
                              ),
                              Icon(Icons.arrow_drop_down)
                            ],
                          )),
                      onTap: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return ShowStatusSelectDialog(context);
                            });
                      },
                    )),
              )
            ],
          )),
    );
  }

  /// 기기 상태 선택 다이얼로그
  Dialog ShowStatusSelectDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 190,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 2, 0, 2),
              color: mBlue,
              height: 40,
              child: Row(
                children: <Widget>[
                  Text(
                    '상태',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
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
                child: ListView(children: <Widget>[
              InkWell(
                child: Container(
                  height: 50,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: lineGray,
                    width: 1,
                  ))),
                  child: Text(
                    '양호',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    pcStatus = '양호';
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 50,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: lineGray,
                    width: 1,
                  ))),
                  child: Text(
                    '고장',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    pcStatus = '고장';
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 50,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: lineGray,
                    width: 1,
                  ))),
                  child: Text(
                    '폐기',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    pcStatus = '폐기';
                  });
                },
              ),
            ]))
          ],
        ),
      ),
    );
  }
}
