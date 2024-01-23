import 'package:flutter/material.dart';
import 'constants.dart';
import 'dlgEditPc.dart';

import 'Comm/commApi.dart';


class AllInfo extends StatefulWidget {
  AllInfoState createState() => AllInfoState();
}


class AllInfoState extends State<AllInfo> {

  String locationValue = '전체';
  String statusValue = '전체';
  String deviceValue = '전체';
  String useValue = '전체';

  ScrollController _scController = ScrollController();
  ScrollController _headerScController = ScrollController();
  bool leftArrow = false;
  bool rightArrow = true;

  double cellWidth = 60.0;
  double cellHeight = 50.0;

  List<Map<String, dynamic>> receiveData = [];
  List<Map<String, dynamic>> totalData = [];

  int itemCount = 0;

  int deviceType = 0;
  int pcItemCount = 0;
  GlobalKey<ScaffoldState> viewKey = GlobalKey<ScaffoldState>();

  var locationList = <String>[
    '전체',
    '본사',
    '외부',
  ];

  var statusList = <String>[
    '전체',
    '양호',
    '고장',
    '폐기',
  ];

  var deviceList = <String>[
    '전체',
    '본체',
    '노트북',
    '맥',
    '모니터',
  ];

  var useList = <String>[
    '전체',
    '사용',
    '미사용'
  ];

  void initState() {
    super.initState();

    _scController.addListener(() {
      _headerScController.jumpTo(_scController.offset);
      if(_scController.position.maxScrollExtent == _scController.offset) {
        setState(() {
          leftArrow = true;
          rightArrow = false;
        });
      } else if (_scController.position.minScrollExtent == _scController.offset) {
        setState(() {
          leftArrow = false;
          rightArrow = true;
        });
      } else {
        setState(() {
          leftArrow = true;
          rightArrow = true;
        });
      }
    });
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
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
          title: Container(
            child: Text('전체 조회', style: TextStyle(fontSize: 17, color: mDarkBlue, fontWeight: FontWeight.bold),),
          ),
        ),
        body: FutureBuilder(
            future: pcDataCall(),
             builder: (context, AsyncSnapshot<Object?> pcListData) {
              if(pcListData.hasError) print(pcListData.error);
              var data = pcListData.data as List<Map<String, dynamic>>?;
              return pcListData.hasData ? _pcHistory(data!) : Center(child: CircularProgressIndicator());
            }
        )
    );
  }

  pcDataCall() async {
    if (receiveData.isEmpty) {
      // return getMachineInfo("");
      return getAssetList(true);
    } else {
      // return receiveData;
      return getAssetList(true);
    }
  }

  Container _pcHistory(List<Map<String, dynamic>> receiveData) {
    this.receiveData = receiveData;

    totalData = dataFilter();

    itemCount = totalData.length;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Container(
          //     height: 90,
          //     padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          //     child: Row(
          //       children: [
          //         Expanded(
          //           flex: 1,
          //           child: Container(
          //             padding: EdgeInsets.all(5),
          //             child: Column(
          //               children: [
          //                 Expanded(
          //                   flex: 1,
          //                   child: Container(
          //                     alignment: Alignment.centerLeft,
          //                     child: Text('  위치'),
          //                   ),
          //                 ),
          //                 Expanded(
          //                   flex: 3,
          //                   child: Container(
          //                     margin: EdgeInsets.all(3),
          //                     padding: EdgeInsets.all(5),
          //                     decoration: BoxDecoration(
          //                         border: Border.all(
          //                             width: 1
          //                         )
          //                     ),
          //                     child: DropdownButton<String>(
          //                       value: locationValue,
          //                       underline:  Container(
          //                         height: 0,
          //                         color: Colors.transparent,
          //                       ),
          //                       icon: Icon(Icons.arrow_drop_down),
          //                       iconSize: 24,
          //                       style: TextStyle(color: Colors.black),
          //                       isExpanded: true,
          //                       onChanged: (String? newValue) {
          //                         setState(() {
          //                           locationValue = newValue!;
          //                         });
          //                       },
          //                       items: locationList.map<DropdownMenuItem<String>>((String value) {
          //                         return DropdownMenuItem<String>(
          //                           value: value,
          //                           child: Text(value),
          //                         );
          //                       }).toList(),
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //         ),
          //         Expanded(
          //           child: Container(
          //             padding: EdgeInsets.all(5),
          //             child: Column(
          //               children: [
          //                 Expanded(
          //                   flex: 1,
          //                   child: Container(
          //                     alignment: Alignment.centerLeft,
          //                     child: Text('  상태'),
          //                   ),
          //                 ),
          //                 Expanded(
          //                   flex: 3,
          //                   child: Container(
          //                     margin: EdgeInsets.all(3),
          //                     padding: EdgeInsets.all(5),
          //                     decoration: BoxDecoration(
          //                         border: Border.all(
          //                             width: 1
          //                         )
          //                     ),
          //                     child: DropdownButton<String>(
          //                       value: statusValue,
          //                       underline:  Container(
          //                         height: 0,
          //                         color: Colors.transparent,
          //                       ),
          //                       icon: Icon(Icons.arrow_drop_down),
          //                       iconSize: 24,
          //                       style: TextStyle(color: Colors.black),
          //                       isExpanded: true,
          //                       onChanged: (String? newValue) {
          //                         setState(() {
          //                           statusValue = newValue!;
          //                         });
          //                       },
          //                       items: statusList.map<DropdownMenuItem<String>>((String value) {
          //                         return DropdownMenuItem<String>(
          //                           value: value,
          //                           child: Text(value),
          //                         );
          //                       }).toList(),
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //         ),
          //         Expanded(
          //           child: Container(
          //             padding: EdgeInsets.all(5),
          //             child: Column(
          //               children: [
          //                 Expanded(
          //                   flex: 1,
          //                   child: Container(
          //                     alignment: Alignment.centerLeft,
          //                     child: Text('  구분'),
          //                   ),
          //                 ),
          //                 Expanded(
          //                   flex: 3,
          //                   child: Container(
          //                     margin: EdgeInsets.all(3),
          //                     padding: EdgeInsets.all(5),
          //                     decoration: BoxDecoration(
          //                         border: Border.all(
          //                             width: 1
          //                         )
          //                     ),
          //                     child: DropdownButton<String>(
          //                       value: deviceValue,
          //                       underline:  Container(
          //                         height: 0,
          //                         color: Colors.transparent,
          //                       ),
          //                       icon: Icon(Icons.arrow_drop_down),
          //                       iconSize: 25,
          //                       style: TextStyle(color: Colors.black),
          //                       isExpanded: true,
          //                       onChanged: (String? newValue) {
          //                         setState(() {
          //                           deviceValue = newValue!;
          //                         });
          //                       },
          //                       items: deviceList.map<DropdownMenuItem<String>>((String value) {
          //                         return DropdownMenuItem<String>(
          //                           value: value,
          //                           child: Text(value),
          //                         );
          //                       }).toList(),
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //         ),
          //         Expanded(
          //           child: Container(
          //             padding: EdgeInsets.all(5),
          //             child: Column(
          //               children: [
          //                 Expanded(
          //                   flex: 1,
          //                   child: Container(
          //                     alignment: Alignment.centerLeft,
          //                     child: Text('  사용/미사용'),
          //                   ),
          //                 ),
          //                 Expanded(
          //                   flex: 3,
          //                   child: Container(
          //                     margin: EdgeInsets.all(3),
          //                     padding: EdgeInsets.all(5),
          //                     decoration: BoxDecoration(
          //                         border: Border.all(
          //                             width: 1
          //                         )
          //                     ),
          //                     child: DropdownButton<String>(
          //                       value: useValue,
          //                       underline:  Container(
          //                         height: 0,
          //                         color: Colors.transparent,
          //                       ),
          //                       icon: Icon(Icons.arrow_drop_down),
          //                       iconSize: 25,
          //                       style: TextStyle(color: Colors.black),
          //                       isExpanded: true,
          //                       onChanged: (String? newValue) {
          //                         setState(() {
          //                           useValue = newValue!;
          //                         });
          //                       },
          //                       items: useList.map<DropdownMenuItem<String>>((String value) {
          //                         return DropdownMenuItem<String>(
          //                           value: value,
          //                           child: Text(value),
          //                         );
          //                       }).toList(),
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //         )
          //       ],
          //     )
          // ),
          // Container(
          //   height: 50,
          //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          //   alignment: Alignment.centerLeft,
          //   child: Row(
          //     children: [
          //       TextButton(
          //           style: TextButton.styleFrom(
          //             // foregroundColor: mBlue,
          //             backgroundColor: mBlue,
          //             shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(5.0),
          //                 side: BorderSide(color: mBlue)
          //             ),
          //           ),
          //           // splashColor: Colors.transparent,
          //           // highlightColor: Colors.transparent,
          //           child: Text('등록', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
          //           onPressed: () {
          //             showDialog(
          //                 barrierDismissible: false,
          //                 context: context,
          //                 builder: (BuildContext context) {
          //                   return ShowEditSelectDialog(context);
          //                 }
          //             );
          //           }
          //       ),
          //     ],
          //   )
          // ),
          Container(
              height: 25,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.centerRight,
              child: Text('수량 : $itemCount')
          ),
          Expanded(
            child: Container(
              color: Colors.yellowAccent,
              child: _pcHistoryDetail(),
            ),
          ),
          InkWell(
            child: Container(
              height: 45,
              color: mBlue,
              // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Text('등록', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
            ),
            onTap: (){
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return ShowEditSelectDialog(context);
                  }
              );
            },
          ),
        ],
      ),
    );
  }

  Column _pcHistoryDetail() {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          height: cellHeight,
          child: _headerList(),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                              color: lineGray,
                              width: 1,
                            )
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildCells(itemCount),
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      controller: _scController,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildRows(itemCount),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _buildCells(int count) {

    return List.generate(
      count,
          (index) => Container(
          alignment: Alignment.center,
          width: 80.0,
          height: cellHeight,
          child: _codeCell(index)
      ),
    );
  }

  Container _codeCell(int index) {
    int num = index+1;

    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: lineGray,
                width: 1,
              )
          )
      ),
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Text('$num', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
      ),
    );
  }

  List<Widget> _buildRows(int count) {
    return List.generate(count, (index) => Container(
          alignment: Alignment.center,
          height: cellHeight,
          child: InkWell(
            child: _detailCell(index),
            onTap: (){
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    // pcEditItem = pcSaveItem;
                    // DlgEditPc(viewKey: viewKey, title: title, pcEditItem: pcEditItem, pcItemCount: pcItemCount, deviceType: deviceType, deviceAdd: false);
                    return DlgEditPc(viewKey: viewKey, title: "", pcEditItem: totalData[index], pcItemCount: pcItemCount, deviceType: deviceType, deviceAdd: false);
                  }
              ).then((val) {
                if (val) {
                  setState(() {});
                }
              });
            },
          ),
        )
    );
  }

  Container _detailCell(int index) {
    Map<String, dynamic>? item = totalData[index];

    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: lineGray,
                  width: 1,
                )
            )
        ),
        child: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: InkWell(
            child: Row(
              children: <Widget>[
                Container(
                  width: cellWidth*2,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(2.0),
                  child: Text(item['no'], style: TextStyle(fontSize: text_size_basic)),
                ),
                Container(
                  width: cellWidth*2,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(2.0),
                  child: Text(item['m_type'], style: TextStyle(fontSize: text_size_basic)),
                ),
                Container(
                  width: cellWidth*2,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(2.0),
                  child: Text(item['m_user'], style: TextStyle(fontSize: text_size_basic)),
                ),
                Container(
                  width: cellWidth*2,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(2.0),
                  child: Text(item['status'], style: TextStyle(fontSize: text_size_basic)),
                ),
                Container(
                  width: cellWidth*2,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(2.0),
                  child: Text(item['m_place'], style: TextStyle(fontSize: text_size_basic)),
                ),
                Container(
                  width: cellWidth*2,
                  height: cellHeight*5,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(2.0),
                  child: Text(item['m_model'], style: TextStyle(fontSize: text_size_basic)),
                ),
                Container(
                  width: cellWidth*2,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(2.0),
                  child: Text(item['m_os'], style: TextStyle(fontSize: text_size_basic)),
                ),
                Container(
                  width: cellWidth*2,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(2.0),
                  child: Text(item['purchase_date'], style: TextStyle(fontSize: text_size_basic)),
                ),
                Container(
                  width: cellWidth*2,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(2.0),
                  child: Text(item['etc'], style: TextStyle(fontSize: text_size_basic)),
                ),
                Container(
                  width: cellWidth*2,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(2.0),
                  child: Text(item['update_time'], style: TextStyle(fontSize: text_size_basic)),
                ),
                // Container(
                //     width: cellWidth*2,
                //     alignment: Alignment.center,
                //     margin: EdgeInsets.all(2.0),
                //     child: Column(
                //       children: [
                //         Expanded(
                //           child:Container(
                //             alignment: Alignment.center,
                //             child: Text(item['update_time'], style: TextStyle(fontSize: text_size_basic)),
                //           ),
                //         ),
                //         Expanded(
                //           child: Container(
                //             alignment: Alignment.center,
                //             child: Text(item['purchase_date'], style: TextStyle(fontSize: text_size_basic)),
                //           ),
                //         )
                //       ],
                //     )
                // ),
              ],
            ),
            onTap: () {
              // Navigator.pop(context);
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    // totalData[index]
                    // item[index];
                    // pcEditItem = pcSaveItem;
                    // DlgEditPc(viewKey: viewKey, title: title, pcEditItem: pcEditItem, pcItemCount: pcItemCount, deviceType: deviceType, deviceAdd: false);
                    return DlgEditPc(viewKey: viewKey, title: "", pcEditItem: totalData[index], pcItemCount: pcItemCount, deviceType: deviceType, deviceAdd: false);
                  }
              ).then((val) {
                if (val) {
                  setState(() {});
                }
              });
            },
          ),
        )
    );
  }

  Stack _headerList() {
    return Stack(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(
                          color: Colors.white,
                          width: 1,
                        )
                    )
                ),
                child: Container(
                  alignment: Alignment.center,
                  color: lineGray,
                  width: 80.0,
                  height: cellHeight,
                  child: Text('NO', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                    controller: _headerScController,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              color: lineGray,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: cellWidth*2,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(2.0),
                                    child: Text('기기번호', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    width: cellWidth*2,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(2.0),
                                    child: Text('자산종류', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    width: cellWidth*2,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(2.0),
                                    child: Text('사용자', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    width: cellWidth*2,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(2.0),
                                    child: Text('상태', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    width: cellWidth*2,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(2.0),
                                    child: Text('사용장소', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    width: cellWidth*2,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(2.0),
                                    child: Text('사양', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    width: cellWidth*2,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(2.0),
                                    child: Text('OS', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    width: cellWidth*2,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(2.0),
                                    child: Text('구입일자', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    width: cellWidth*2,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(2.0),
                                    child: Text('비고', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    width: cellWidth*2,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(2.0),
                                    child: Text('수정시각', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  ),
                                  // Container(
                                  //   width: cellWidth*2,
                                  //   alignment: Alignment.center,
                                  //   margin: EdgeInsets.all(2.0),
                                  //   child: Column(
                                  //     children: [
                                  //       Expanded(
                                  //         child: Container(
                                  //           alignment: Alignment.center,
                                  //           child: Text('사용일', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  //         ),
                                  //       ),
                                  //       Expanded(
                                  //         child: Container(
                                  //           alignment: Alignment.center,
                                  //           child: Text('반납일', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  //         ),
                                  //       )
                                  //     ],
                                  //   )
                                  // ),
                                ],
                              ),
                            )
                        ),
                      ],
                    )
                ),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                color: Colors.transparent,
                width: 80.0,
                height: cellHeight,
              ),
              Visibility(
                visible: leftArrow,
                child: Icon(Icons.arrow_back_ios, color: Colors.black54, size: 20,),
              ),
              Spacer(),
              Visibility(
                visible: rightArrow,
                child: Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 20,),
              )
            ],
          ),
        )
      ],
    );
  }

  List<Map<String, dynamic>> dataFilter() {
    List<Map<String, dynamic>> result = [];
    result.addAll(receiveData);

    for(int i = 0; i < receiveData.length; i++) {
      Map<String, dynamic> item = receiveData[i];

      // 위치
      if (locationValue != "전체" && locationValue == "본사") {
        if (item['location'] != "본사") {
          result.remove(item);
        }
      } else if (locationValue != "전체" && locationValue == "외부") {
        if (item['location'] == "본사") {
          result.remove(item);
        }
      }

      // 상태
      if (statusValue != "전체" && item['status'] != statusValue) {
        result.remove(item);
      }

      // 기기
      if (deviceValue != "전체") {
        String id = "";
        if (deviceValue == "본체") {
          id = "P";
        } else if (deviceValue == "노트북") {
          id = "N";
        } else if (deviceValue == "맥") {
          id = "I";
        } else if (deviceValue == "모니터") {
          id = "M";
        } else if (deviceValue == "서버") {
          id = "S";
        }

        if (!item['no'].contains(id)) {
          result.remove(item);
        }
      }

      // 사용중
      if (useValue != "전체") {
        if (useValue == "사용" && item['returndate'].toString() != "") {
          result.remove(item);
        } else if (useValue == "미사용" && item['returndate'].toString() == "") {
          result.remove(item);
        }
      }
    }

    return deviceSort(result);
  }

  /// 기기등록 선택 다이얼로그
  Dialog ShowEditSelectDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width*0.7,
        height: 240,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 2, 0, 2),
              color: mBlue,
              height: 40,
              child: Row(
                children: <Widget>[
                  Text('기기 선택', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),),
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
                          height: 40,
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
                          child: Text('본체', style: TextStyle(fontSize: 15, color: Colors.black),),
                        ),
                        onTap: () {
                          Navigator.pop(context);

                          deviceType = 0;
                          moveEditDialog(context);
                        },
                      ),
                      InkWell(
                        child: Container(
                          height: 40,
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
                          child: Text('노트북', style: TextStyle(fontSize: 15, color: Colors.black),),
                        ),
                        onTap: () {
                          Navigator.pop(context);

                          deviceType = 1;
                          moveEditDialog(context);
                        },
                      ),
                      InkWell(
                        child: Container(
                          height: 40,
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
                          child: Text('맥', style: TextStyle(fontSize: 15, color: Colors.black),),
                        ),
                        onTap: () {
                          Navigator.pop(context);

                          deviceType = 2;
                          moveEditDialog(context);
                        },
                      ),
                      InkWell(
                        child: Container(
                          height: 40,
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
                          child: Text('모니터', style: TextStyle(fontSize: 15, color: Colors.black),),
                        ),
                        onTap: () {
                          Navigator.pop(context);

                          deviceType = 3;
                          moveEditDialog(context);
                        },
                      ),
                      InkWell(
                        child: Container(
                          height: 40,
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
                          child: Text('서버', style: TextStyle(fontSize: 15, color: Colors.black),),
                        ),
                        onTap: () {
                          Navigator.pop(context);

                          deviceType = 4;
                          moveEditDialog(context);
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

  /// 기기등록 다이얼로그 표시
  void moveEditDialog(BuildContext context) {
    switch(deviceType) {
      case 0:   // P
        pcItemCount = 16;
        break;
      case 1:   // N
        pcItemCount = 17;
        break;
      case 2:   // I
        pcItemCount = 17;
        break;
      case 3:   // M
        pcItemCount = 7;
        break;
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: new DlgEditPc(viewKey: viewKey, pcEditItem: Map(), pcItemCount: pcItemCount, deviceType: deviceType, deviceAdd: true),
          );
        }
    );
  }
}