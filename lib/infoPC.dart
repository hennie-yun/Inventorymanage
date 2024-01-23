import 'package:flutter/material.dart';
import 'historyPC.dart';
import 'historyUser.dart';
import 'dlgEditPc.dart';
import 'constants.dart';

import 'Comm/commApi.dart';

class InfoPC extends StatefulWidget {
  String pcName;

  InfoPC(this.pcName);

  InfoPCState createState() => InfoPCState();
}

class InfoPCState extends State<InfoPC> {
  String userName = "";
  double cellHeight = 40.0;
  TextStyle titleStyle = TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold);

  Map<String, dynamic>? pcSaveItem;
  Map<String, dynamic>? userSaveItem;
  List<Map<String, dynamic>>? userSaveData;
  int pcItemCount = 0;
  String pcStatus = '양호';
  String title = '';

  int deviceType = 0;

  Map<String, dynamic>? pcEditItem;
  Map<String, dynamic>? userEditItem;

  List<Map<String, dynamic>>? userItems;

  GlobalKey<ScaffoldState> viewKey = GlobalKey<ScaffoldState>();

  int ssdCount = 3;
  int hddCount = 3;

  void initState() {
    userName = "";
    pcEditItem = Map();
    userEditItem = Map();

    widget.pcName = widget.pcName.toUpperCase();

    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  void resetInfoData(String pcName) {
    setState(() {
      widget.pcName = pcName.toUpperCase();
    });
  }

  Widget build(BuildContext context) {
    title = deviceTypeString(widget.pcName)!;

    return Scaffold(
      key: viewKey,
      appBar: AppBar(
        backgroundColor: mYellow,
        // brightness: Brightness.light,
        titleSpacing: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20, color: mDarkBlue,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: InkWell(
          child: Container(
            padding: EdgeInsets.only(bottom: 0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      color: mDarkBlue,
                      width: 1,
                    )
                )
            ),
            child: Text(title, style: TextStyle(fontSize: 17, color: mDarkBlue, fontWeight: FontWeight.bold),),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPC(widget.pcName)));
          },
        ),
        actions: <Widget>[
          Visibility(
            visible: adminLogin,
            child: ButtonTheme(
              minWidth: 20,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red, // foreground
                  padding: EdgeInsets.all(5),
                ),
                // splashColor: Colors.transparent,
                // highlightColor: Colors.transparent,
                child: Text('편집', style: TextStyle(fontSize: 15, color: mDarkBlue),),
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return ShowEditSelectDialog(context);
                    }
                  );
                },
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: getMachineInfo(widget.pcName),
        builder: (context, machineListData) {
          if (machineListData.hasError) print(machineListData.error);
          var data = machineListData.data as List<Map<String, dynamic>>?;
          return machineListData.hasData ? _infoPcMainData(data!) : Center(child: CircularProgressIndicator());
      }),
    );
  }

  Future _infoPcMain(List<Map<String, dynamic>> userData) async {
    userItems = await getUserListUser(userData[0]['name'], false);

    if (userItems!.length > 1) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return ShowSelectDialog(context, userItems!);
          }
      );
    } else {
      showSnackBar(viewKey, "다른 기기가 없습니다.");
    }
  }

  Container _infoPcMainData(List<Map<String, dynamic>> totalData) {
    List<Map<String, dynamic>> pcData = totalData[0]['pcData'];
    List<Map<String, dynamic>> userData = totalData[0]['userData'];

    Map<String, dynamic> pcItem = pcData[0];
    Map<String, dynamic> userItem = userData[0];

    userName = userItem['name'].toString();
    pcSaveItem = pcItem;
    userSaveItem = userItem;
    if(pcItem['status'] != null) {
      pcStatus = pcItem['status'];
    }
    userSaveData = userData;

    // 기기 종류 설정
    if (pcItem['no'].toString().contains("P")) {
      deviceType = 0;
    } else if (pcItem['no'].toString().contains("N")) {
      deviceType = 1;
    } else if (pcItem['no'].toString().contains("I")) {
      deviceType = 2;
    } else if (pcItem['no'].toString().contains("M")) {
      deviceType = 3;
    }

    // 기기 종류에 따라 표시되는 갯수 제한
      // P : -5
      // N : -4
      // M : -14
    switch(deviceType) {
      case 0:   // P
        pcItemCount = pcItem.length - 3;
        break;
      case 1:   // N
        pcItemCount = pcItem.length - 2;
        break;
      case 2:   // I
        pcItemCount = pcItem.length - 2;
        break;
      case 3:   // M
        pcItemCount = pcItem.length - 12;
        break;
    }

    if (deviceType != 3) { // 모니터 이외의 기기에서만
      // SSD, HDD 아이템 카운트
      ssdCount = 3;
      if (pcItem['ssd1'].toString() == "") {
        ssdCount -= 1;
        pcItemCount -= 1;
      }
      if (pcItem['ssd2'].toString() == "") {
        ssdCount -= 1;
        pcItemCount -= 1;
      }
      if (pcItem['ssd3'].toString() == "") {
        ssdCount -= 1;
        pcItemCount -= 1;
      }

      hddCount = 3;
      if (pcItem['hdd1'].toString() == "") {
        hddCount -= 1;
        pcItemCount -= 1;
      }
      if (pcItem['hdd2'].toString() == "") {
        hddCount -= 1;
        pcItemCount -= 1;
      }
      if (pcItem['hdd3'].toString() == "") {
        hddCount -= 1;
        pcItemCount -= 1;
      }
    }

    return Container(
        child: Column(
          children: [
            Container(
              height: 40,
              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              alignment: Alignment.centerRight,
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.only(bottom: 0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: mBlue,
                            width: 0.5,
                          )
                      )
                  ),
                  child: Text('다른기기보기', style: TextStyle(fontSize: 13, color: mBlue, fontWeight: FontWeight.bold),),
                ),
                onTap: () {
                  _infoPcMain(userData);
                },
              ),
            ),
            Container(
              height: cellHeight*3+10+4,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Container(
                  color: mDarkBlue,
                  padding: EdgeInsets.all(0.5),
                  child: Column(
                    children: [
                      Container(
                          color: mDarkBlue,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: cellHeight,
                                  margin: EdgeInsets.all(0.5),
                                  alignment: Alignment.center,
                                  color: mSkyBlue,
                                  child: Text('사용자', style: titleStyle),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Container(
                                  height: cellHeight,
                                  margin: EdgeInsets.all(0.5),
                                  alignment: Alignment.center,
                                  color: Colors.white,
                                  child:InkWell(
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 0),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                color: mBlue,
                                                width: 0.5,
                                              )
                                          )
                                      ),
                                      child: Text(userItem['name'].toString(), style: TextStyle(fontSize: 15, color: mBlue, fontWeight: FontWeight.bold),),
                                    ),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryUser(userItem['name'].toString())));
                                    },
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                          color: mDarkBlue,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: cellHeight,
                                  margin: EdgeInsets.all(0.5),
                                  alignment: Alignment.center,
                                  color: mSkyBlue,
                                  child: Text('사용일자', style: titleStyle),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Container(
                                  height: cellHeight,
                                  margin: EdgeInsets.all(0.5),
                                  alignment: Alignment.center,
                                  color: Colors.white,
                                  child: Text(userItem['usedate'].toString()),
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                          color: mDarkBlue,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: cellHeight,
                                  margin: EdgeInsets.all(0.5),
                                  alignment: Alignment.center,
                                  color: mSkyBlue,
                                  child: Text('반납일자', style: titleStyle),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Container(
                                  height: cellHeight,
                                  margin: EdgeInsets.all(0.5),
                                  alignment: Alignment.center,
                                  color: Colors.white,
                                  child: Text(userItem['returndate'].toString()),
                                ),
                              )
                            ],
                          )
                      )
                    ],
                  ),
                )
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    height: (cellHeight*(pcItemCount))+(0.5*(pcItemCount)*2)+11,
                    child: Container(
                      color: mDarkBlue,
                      padding: EdgeInsets.all(0.5),
                      child: InfoPCView(context)
                    ),
                  )
              ),
            ),
          ],
        )
    );
  }

  Column? InfoPCView(BuildContext context) {
    if(deviceType == 0) {
      return Column(
        children: [
          _detailInfo('CPU', 'cpu'),
          if (ssdCount > 0) _detailInfo('SSD1', 'ssd1'),
          if (ssdCount > 1) _detailInfo('SSD2', 'ssd2'),
          if (ssdCount > 2) _detailInfo('SSD3', 'ssd3'),
          if (hddCount > 0) _detailInfo('HDD1', 'hdd1'),
          if (hddCount > 1) _detailInfo('HDD2', 'hdd2'),
          if (hddCount > 2) _detailInfo('HDD3', 'hdd3'),
          _detailInfo('메모리', 'mem'),
          _detailInfo('OS', 'os'),
          _detailInfo('VGA', 'vga'),
          _detailInfo('상태', 'status'),
          _detailInfo('구입가', 'price'),
          _detailInfo('위치', 'location'),
          _detailInfo('입고일', 'fromdate'),
          _detailInfo('수정일', 'updatedate'),
          _detailInfo('비고', 'etc'),
        ],
      );
    } else if(deviceType == 1 || deviceType == 2) {

      return Column(
        children: [
          _detailInfo('모델명', 'model'),
          _detailInfo('CPU', 'cpu'),
          if (ssdCount > 0) _detailInfo('SSD1', 'ssd1'),
          if (ssdCount > 1) _detailInfo('SSD2', 'ssd2'),
          if (ssdCount > 2) _detailInfo('SSD3', 'ssd3'),
          if (hddCount > 0) _detailInfo('HDD1', 'hdd1'),
          if (hddCount > 1) _detailInfo('HDD2', 'hdd2'),
          if (hddCount > 2) _detailInfo('HDD3', 'hdd3'),
          _detailInfo('메모리', 'mem'),
          _detailInfo('OS', 'os'),
          _detailInfo('VGA', 'vga'),
          _detailInfo('상태', 'status'),
          _detailInfo('구입가', 'price'),
          _detailInfo('위치', 'location'),
          _detailInfo('입고일', 'fromdate'),
          _detailInfo('수정일', 'updatedate'),
          _detailInfo('비고', 'etc'),
        ],
      );
    } else if(deviceType == 3){
      return Column(
        children: [
          _detailInfo('모델명', 'model'),
          _detailInfo('상태', 'status'),
          _detailInfo('구입가', 'price'),
          _detailInfo('위치', 'location'),
          _detailInfo('입고일', 'fromdate'),
          _detailInfo('수정일', 'updatedate'),
          _detailInfo('비고', 'etc'),
        ],
      );
    }

  }
  Container _detailInfo(String titleStr, String valueStr) {
    String valueText = '';

    if(pcSaveItem?[valueStr].toString() != 'null') {
      valueText = pcSaveItem![valueStr].toString();
    }

    if(titleStr != '비고') {
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
                    color: mSkyBlue,
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
                    child: Text(valueText),
                  ),
                )
              ],
            )
        ),
      );
    } else {
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
                    color: mSkyBlue,
                    child: Text(titleStr, style: titleStyle),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return ShowEtcDialog(context, valueText);
                          }
                      );
                    },
                    child: Container(
                      height: cellHeight,
                      margin: EdgeInsets.all(0.5),
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Text(valueText),
                    ),
                  ),
                )
              ],
            )
        ),
      );
    }
  }

  Dialog ShowSelectDialog(BuildContext context, List<Map<String, dynamic>> userData) {

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width*0.7,
        height: 250,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 2, 0, 2),
              color: mBlue,
              height: 40,
              child: Row(
                children: <Widget>[
                  Text('PC', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.clear, size: 25, color: Colors.white,),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: userData.length,
                itemBuilder: _userPcInfo,
              )
            )
          ],
        ),
      ),
    );
  }

  Dialog ShowEtcDialog(BuildContext context, String message) {

    return Dialog(
      backgroundColor: Colors.white,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: MediaQuery.of(context).size.width*0.7,
          height: 300,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: Text('$message'),
                    )
                  )
                )
              )
            ],
          ),
        ),
      )
    );
  }

  Widget _userPcInfo(BuildContext context, int index) {
    Map<String, dynamic> userItem = userItems![index];
    String pName = deviceTypeString(userItem['no'])!;

    return InkWell(
      child: Column(
        children: [
          Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
            alignment: Alignment.center,
            child: Text(pName, style: TextStyle(fontSize: 13, color: Colors.black),),
          ),
          SizedBox(
            height: 0.2,
            child: Container(
              color: Colors.grey,
            ),
          )
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        resetInfoData(userItem['no']);
      },
    );
  }


  Dialog ShowEditSelectDialog(BuildContext context) {

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width*0.7,
        height: 200,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 2, 0, 2),
              color: mBlue,
              height: 40,
              child: Row(
                children: <Widget>[
                  Text('편집', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.clear, size: 25, color: Colors.white,),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
            Expanded(
                child: ListView(
                  children: <Widget>[
                  InkWell(
                    child: Container(
                      height: 80,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: lineGray,
                                width: 1,
                              )
                          )
                      ),
                      child: Text('기기 편집', style: TextStyle(fontSize: 15, color: Colors.black),),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            pcEditItem = pcSaveItem;
                            return DlgEditPc(viewKey: viewKey, title: title, pcEditItem: pcEditItem, pcItemCount: pcItemCount, deviceType: deviceType, deviceAdd: false);
                          }
                      ).then((val) {
                        if (val) {
                          setState(() {});
                        }
                      });
                    },
                  ),
                    InkWell(
                      child: Container(
                        height: 80,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: lineGray,
                              width: 1,
                            )
                          )
                        ),
                        child: Text('사용자 편집', style: TextStyle(fontSize: 15, color: Colors.black),),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return ShowUserEditDialog(context);
                          }
                        );
                      },
                    ),
                 ]
                )
            )
          ],
        ),
      ),
    );
  }

  /// 사용자편집 다이얼로그
  Dialog ShowUserEditDialog(BuildContext context) {
    userEditItem = userSaveItem;

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
                          child: Text('$title 사용자 편집', style: TextStyle(fontSize: 17, color: mDarkBlue, fontWeight: FontWeight.bold),),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.black, size: 25,),
                          onPressed: () {
                            print(userEditItem);
                            postSetUser(
                                userEditItem!["no"].toString().toUpperCase(),
                                userEditItem?["name"],
                                userEditItem?["usedate"],
                                userEditItem?["returndate"],
                                userEditItem?["userEtc"]
                            ).then((value) {
                              if(value) {
                                print('[편집] postSetUser : $value');
                                showSnackBar(viewKey, "저장 완료");
                                setState(() {});
                              }else {
                                showSnackBar(viewKey, "저장 실패");
                              }
                              Navigator.pop(context);
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.black, size: 25,),
                          onPressed: () {
                            userEditItem = userSaveItem;
                            print(userEditItem);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      height: (cellHeight*4)+(0.5*4*2)+11,
                      child: Container(
                        color: mDarkBlue,
                        padding: EdgeInsets.all(0.5),
                        child: Column(
                          children: [
                            _userInfoEdit('사용자', 'name'),
                            _userInfoEdit('사용일자', 'usedate'),
                            _userInfoEdit('반납일자', 'returndate'),
                            _userInfoEdit('비고', 'userEtc'),
                          ],
                        ),
                      ),
                    )
                ),
              )
            ],
          )
      ),
    );
  }

  Container _userInfoEdit(String titleStr, String valueStr) {
    final textField = TextEditingController();

    if(userSaveItem?[valueStr].toString() != 'null') {
      textField.text = userSaveItem![valueStr].toString();
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
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black,),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black,),
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
                          )
                      ),
                      onChanged: (data) {
                        setState(() {
                          userEditItem?[valueStr] = data;
                        });
                      },
                    ),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}