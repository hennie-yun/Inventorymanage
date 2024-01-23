import 'package:flutter/material.dart';
import 'constants.dart';
import 'infoPC.dart';

import 'Comm/commApi.dart';

/// ////////////////////
/// 사용자 검색 화면 ///
/// ////////////////////
class SearchUser extends StatefulWidget {
  SearchUserState createState() => SearchUserState();
}

class SearchUserState extends State<SearchUser> {

  String userName = "";
  final userTextField = TextEditingController();
  GlobalKey<ScaffoldState> viewKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>>? userSaveData;

  @override
  void initState() {
    userName = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: viewKey,
      resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
            alignment: Alignment.center,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                    child: Column(
                      children: [
                        Center(
                          child: Image(image: AssetImage('images/smSoftLabPc.png')),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(top: 10),
                          child: Text('사용자 검색', style: TextStyle(color: mBlue, fontSize: 30, fontWeight: FontWeight.bold),),
                        )
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    Container(
                      height: 60,
                      padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                      child: TextFormField(
                        controller: userTextField,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: mBlue,),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: '사용자',
                            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey,),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueGrey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueGrey,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            )
                        ),
                        onChanged: (data) {
                          setState(() {
                            userName = data;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: mBlue, //
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: mBlue)
                          ),
                        ),
                        // splashColor: Colors.transparent,
                        // highlightColor: Colors.transparent,
                        child: Text('검색', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if(userTextField.text != "") {
                            getUserListUser(userName.trim(), false).then((List<Map<String, dynamic>> data) {
                              if(data.length > 1) {
                                userSaveData = data;
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ShowSelectDialog(context, data);
                                    }
                                );
                              } else {
                                if(data.length == 1) {
                                  moveInfo(context, data[data.length-1]['no']);
                                } else {
                                  showSnackBar(viewKey, '사용자가 없습니다.');
                                }
                              }
                            });
                          } else {
                            showSnackBar(viewKey, '사용자를 입력해주세요.');
                          }
                        },
                      ),
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                  color: mBlue,
                                  width: 0.5,
                                )
                            )
                        ),
                        child: Text('기기로 검색', style: TextStyle(fontSize: 15, color: mBlue, fontWeight: FontWeight.bold),),
                      ),
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        // viewKey.currentState?.removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        Navigator.pushReplacementNamed(context, '/searchPC');
                      },
                    ),
                  ],
                ),
                Spacer()
              ],
            )
        )
      ),
    );
  }

  /// 기기 상세정보 표시 화면으로 이동
  void moveInfo(BuildContext context, String pcName) {
    FocusScope.of(context).unfocus();
    // viewKey.currentState?.removeCurrentSnackBar();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    Navigator.push(context, MaterialPageRoute(builder: (context) => InfoPC(pcName)));
    userTextField.text = '';
  }

  /// 기기 선택 다이얼로그 표시
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
                  itemBuilder: _listContactInfo,
                )
            )
          ],
        ),
      ),
    );
  }

  /// 기기 리스트
  Widget _listContactInfo(BuildContext context, int index) {
    Map<String, dynamic> userItem = userSaveData![index];
    String pName = userItem['no'];
    pName = deviceTypeString(pName)!;

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
        moveInfo(context, userItem['no']);
      },
    );
  }

}