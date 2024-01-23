import 'package:flutter/material.dart';
import 'constants.dart';

import 'Comm/commApi.dart';

class HistoryUser extends StatefulWidget {
  String userName;

  HistoryUser(this.userName);

  HistoryUserState createState() => HistoryUserState();
}

class HistoryUserState extends State<HistoryUser> {
  String title = '';
  double? cellWidth;
  double cellHeight = 40.0;
  ScrollController _scController = ScrollController();
  ScrollController _headerScController = ScrollController();
  bool leftArrow = false;
  bool rightArrow = true;

  List<Map<String, dynamic>> userData = [];

  void initState() {
    title = widget.userName + '님 히스토리';

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

    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Text(title, style: TextStyle(fontSize: 17,
                color: mDarkBlue,
                fontWeight: FontWeight.bold),),
          ),
        ),
        body: FutureBuilder(
          future: dataCall(),
          builder: (context, userListData) {
            if(userListData.hasError) print(userListData.error);
            var data = userListData.data as List<Map<String, dynamic>>?;
            return userListData.hasData ? _userHistory(data!) : Center(child: CircularProgressIndicator());
        }
      )
    );
  }

  dataCall() async {
    if (userData.isEmpty) {
      return getUserListUser(widget.userName, true);
    } else {
      return userData;
    }
  }

  Column _userHistory(List<Map<String, dynamic>> data) {
    this.userData = data;
    Map<String, dynamic> userItem = data[userData.length-1];
    cellWidth = (MediaQuery.of(context).size.width - 94)/(userItem.length-3);

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
                      children: _buildCells(userData.length),
                    ),
                  ),
                  SizedBox(
                    width: 1,
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      controller: _scController,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildRows(userData.length, userData),
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
        child: _codeCell(index),
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

  List<Widget> _buildRows(int count, List<Map<String, dynamic>> data) {
    return List.generate(
      count,
      (index) => Container(
        alignment: Alignment.center,
        height: cellHeight,
        child: _detailCell(index, data),
        )
    );
  }

  Container _detailCell(int index, List<Map<String, dynamic>> data) {
    Map<String, dynamic> item = data[index];

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
        child: Row(
          children: <Widget>[
            Container(
              width: cellWidth,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['no'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            Container(
              width: cellWidth,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['usedate'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            Container(
              width: cellWidth,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['returndate'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            Container(
              width: cellWidth,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['etc'].toString(), style: TextStyle(fontSize: text_size_basic)),
            )
          ],
        ),
      ),
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
                child:
                Container(
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
                    physics: ClampingScrollPhysics(),
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
                                    width: cellWidth,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(2.0),
                                    child: Text('기기번호', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    width: cellWidth,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(2.0),
                                    child: Text('사용일자', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    width: cellWidth,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(2.0),
                                    child: Text('반납일자', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  ),Container(
                                    width: cellWidth,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(2.0),
                                    child: Text('비고', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                  ),
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
}
