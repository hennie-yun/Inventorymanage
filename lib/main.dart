import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'searchUser.dart';
import 'searchPC.dart';
import 'infoPC.dart';
import 'historyPC.dart';
import 'historyUser.dart';
import 'constants.dart';
import 'allInfo.dart';
import 'Comm/commApi.dart';
import 'dlgEditPc.dart';

void main() {
  runApp(MaterialApp(
    home: SearchPC(),
    routes: <String, WidgetBuilder> {
      '/searchPC' : (BuildContext context) => SearchPC(),
      '/searchUser' : (BuildContext context) => SearchUser(),
      '/infoPC' : (BuildContext context) => InfoPC(''),
      '/historyPC' : (BuildContext context) => HistoryPC(''),
      '/historyUser' : (BuildContext context) => HistoryUser(''),
      '/allInfo' : (BuildContext context) => AllInfo(),
      // '/searchPC' : (BuildContext context) => SearchPC(),
    },
  ));
}

class MyApp extends StatefulWidget {
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

/// 로그인 화면
class Login extends StatefulWidget {
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> with WidgetsBindingObserver {

  String idValue = '';
  String pwValue = '';
  final idTextField = TextEditingController();
  final pwTextField = TextEditingController();
  GlobalKey<ScaffoldState> viewKey = GlobalKey<ScaffoldState>();

  SharedPreferences? pref;

  // 생체인증 가능여부
  bool bioLogin = false;
  var localAuth = LocalAuthentication();
  List<BiometricType> availableBiometrics = [];

  @override
  void initState() {
    setPref();
    super.initState();
  }

  /// 저장 데이터 불러오기
  Future<void> setPref() async {
    pref = await SharedPreferences.getInstance();
    bioLogin = pref!.getBool('bioLogin')!;

    String? saveId = pref!.getString('id');
    String? savePW = pref!.getString('pw');
    if (bioLogin && saveId != null && saveId != "" && savePW != null && savePW != "") {
      bioCheck();
    } else {
      bioLogin = false;
      pref!.setBool('bioLogin', bioLogin);
    }
  }

  /// 생체인증 기능 체크
  Future<void> bioCheck() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        showSnackBar(viewKey, "현재 기기는 생체인증을 사용할 수 없습니다.");
      } else {
        var authCount = await localAuth.getAvailableBiometrics();
        if (authCount.length > 0) {
          bool auth = await LocalAuthentication().authenticateWithBiometrics(localizedReason: '생체인증을 진행합니다.');
          if (auth) {
            setState(() {
              idValue = pref!.getString('id')!;
              pwValue = pref!.getString('pw')!;
              idTextField.text = idValue;
              pwTextField.text = pwValue;
            });
            login();
          } else {
            showSnackBar(viewKey, "생체인증에 실패하였습니다.");
          }
        } else {
          showSnackBar(viewKey, "지문을 등록해주세요.");
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
      key: viewKey,
      resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 화면 상단 로고
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image(image: AssetImage('images/smSoftLabPc.png')),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(top: 10),
                        child: Text('PC 관리', style: TextStyle(color: mBlue, fontSize: 30, fontWeight: FontWeight.bold),),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                        /// 텍스트 필드 (ID)
                        child: TextFormField(
                          controller: idTextField,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: mBlue,),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintText: 'ID',
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
                              idValue = data;
                            });
                          },
                        ),
                      ),
                      Container(
                        height: 60,
                        padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                        /// 텍스트 필드 (PW)
                        child: TextFormField(
                          obscureText: true,
                          controller: pwTextField,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: mBlue,),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintText: 'PW',
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
                              pwValue = data;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 60,
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                        /// 로그인 버튼
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
                          child: Text('로그인', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                          onPressed: () {
                            login();
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }

  /// 로그인 눌렀을 때
  login() async {
    FocusScope.of(context).unfocus();
    if(idValue.trim() != "" && idTextField.text != "" && pwValue.trim() != "" && pwTextField.text != "") {
      print("[로그인] ID : $idValue || PW : $pwValue");
      List<Map<String, dynamic>> result = await getLogin(idValue, pwValue);
      if (result.length > 0) {
        if(idValue == 'admin') {
          adminLogin = true;
        }
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        // viewKey.currentState?.removeCurrentSnackBar();
        Navigator.pushReplacementNamed(context, '/searchPC');
        idTextField.text = '';
        pwTextField.text = '';

        pref!.setString('id', idValue);
        pref!.setString('pw', pwValue);
      } else {
        // 로그인 정보가 틀렸을 때
        showSnackBar(viewKey, "로그인 실패");
      }
    } else {
      // 아무것도 입력 안했을 때
      showSnackBar(viewKey, "다시 입력해주세요.");
    }
  }
}