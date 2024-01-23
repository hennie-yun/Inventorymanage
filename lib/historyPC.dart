import 'package:flutter/material.dart';
import 'constants.dart';

import 'Comm/commApi.dart';

class HistoryPC extends StatefulWidget {
  String pcName;

  HistoryPC(this.pcName);

  HistoryPCState createState() => HistoryPCState();
}

class HistoryPCState extends State<HistoryPC> {
  String title = '';
  double cellWidth = 80.0;
  double cellHeight = 70.0;
//  int itemCount = 20;
  ScrollController _scController = ScrollController();
  ScrollController _headerScController = ScrollController();
  bool leftArrow = false;
  bool rightArrow = true;

  int deviceType = 0;

  List<Map<String, dynamic>> pcData = [];

//  List<Map<String, dynamic>> detailData;

  void initState() {
    widget.pcName = widget.pcName.toUpperCase();
    // 기기 종류 설정
    deviceType = deviceTypeInt(widget.pcName)!;
    title = "${deviceTypeString(widget.pcName)} 히스토리";
    if (deviceType == 3) cellHeight = 50.0;

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
            builder: (context, pcListData) {
              if(pcListData.hasError) print(pcListData.error);
              var data = pcListData.data as List<Map<String, dynamic>>?;
              return pcListData.hasData ? _pcHistory(data!) : Center(child: CircularProgressIndicator());
            }
        )
    );
  }

  dataCall() async {
    if (pcData.isEmpty) {
      return getMachineList(widget.pcName);
    } else {
      return pcData;
    }
  }

  Column _pcHistory(List<Map<String, dynamic>> pcData) {
    this.pcData = pcData;

    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          height: 50,
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
                      children: _buildCells(pcData.length),
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      controller: _scController,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildRows(pcData.length),
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
        child: _codeCell(index, pcData[index])
      ),
    );
  }

  Container _codeCell(int index, Map<String, dynamic> pcItem) {
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
    return List.generate(
        count,
        (index) => Container(
          alignment: Alignment.center,
          height: cellHeight,
          child: _detailCell(index),
        )
    );
  }

  Container _detailCell(int index) {
    Map<String, dynamic> item = pcData[index];

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
            if (deviceType != 0) Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['model'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            if (deviceType != 3) Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['cpu'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            if (deviceType != 3) Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['ssd1'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            if (deviceType != 3) Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['ssd2'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            if (deviceType != 3) Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['ssd3'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            if (deviceType != 3) Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['hdd1'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            if (deviceType != 3) Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['hdd2'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            if (deviceType != 3) Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['hdd3'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            if (deviceType != 3) Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['mem'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            if (deviceType != 3) Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['os'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            if (deviceType != 3) Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['vga'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['status'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['price'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['location'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['fromdate'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['updatedate'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
            Container(
              width: cellWidth*2,
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.0),
              child: Text(item['etc'].toString(), style: TextStyle(fontSize: text_size_basic)),
            ),
          ],
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
                                if (deviceType != 0) Container(
                                  width: cellWidth*2,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2.0),
                                  child: Text('모델', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                ),
                                if (deviceType != 3) Container(
                                  width: cellWidth*2,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2.0),
                                  child: Text('CPU', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                ),
                                if (deviceType != 3) Container(
                                  width: cellWidth*2,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2.0),
                                  child: Text('SSD1', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                ),
                                if (deviceType != 3) Container(
                                  width: cellWidth*2,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2.0),
                                  child: Text('SSD2', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                ),
                                if (deviceType != 3) Container(
                                  width: cellWidth*2,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2.0),
                                  child: Text('SSD3', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                ),
                                if (deviceType != 3) Container(
                                  width: cellWidth*2,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2.0),
                                  child: Text('HDD1', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                ),
                                if (deviceType != 3) Container(
                                  width: cellWidth*2,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2.0),
                                  child: Text('HDD2', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                ),
                                if (deviceType != 3) Container(
                                  width: cellWidth*2,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2.0),
                                  child: Text('HDD3', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                ),
                                if (deviceType != 3) Container(
                                  width: cellWidth*2,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2.0),
                                  child: Text('메모리', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                ),
                                if (deviceType != 3) Container(
                                  width: cellWidth*2,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2.0),
                                  child: Text('OS', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                ),
                                if (deviceType != 3) Container(
                                  width: cellWidth*2,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2.0),
                                  child: Text('VGA', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
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
                                  child: Text('구입가', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  width: cellWidth*2,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2.0),
                                  child: Text('위치', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  width: cellWidth*2,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2.0),
                                  child: Text('입고일', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  width: cellWidth*2,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2.0),
                                  child: Text('수정일', style: TextStyle(fontSize: text_size_basic, fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  width: cellWidth*2,
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
