import 'dart:async';
import 'dart:convert';
import 'package:fluttersmsoftlabpc/constants.dart';
import 'package:http/http.dart' as http;

final ServerUrl = 'http://203.109.30.207:8585';

class ApiResult {
  final String? errCode;
  final String? errMsg;
  final List<dynamic>? result;


  ApiResult({this.errCode, this.errMsg, this.result});

  factory ApiResult.fromJson(Map<String, dynamic> json) {
    return ApiResult(
      result: json['data'],
    );
  }
}

/// //////////////////////////////////조회성 통신(GET)///////////////////////////////////////////////

/// 기기 히스토리 가져오기
Future<List<Map<String, dynamic>>> getMachineList(String pcNo) async {
  print('$ServerUrl/getMachineList?no=$pcNo');
  try {
    final response = await http.get('$ServerUrl/getMachineList?no=$pcNo' as Uri).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
      ApiResult machineListResult = ApiResult.fromJson(json.decode(response.body));
      List<Map<String, dynamic>> result = [];
      if(machineListResult.errCode == null) {
        for(int i=0; i<machineListResult.result!.length; i++) {
          Map<String, dynamic> item = machineListResult.result?[i];
          result.add({
            'idx': item['idx'],
            'no': item['no'],
            'cpu': item['cpu'],
            'ssd1': item['ssd1'],
            'ssd2': item['ssd2'],
            'ssd3': item['ssd3'],
            'hdd1': item['hdd1'],
            'hdd2': item['hdd2'],
            'hdd3': item['hdd3'],
            'os': item['os'],
            'vga': item['vga'],
            'fromdate': item['fromdate'],
            'updatedate': item['updatedate'],
            'location': item['location'],
            'etc': item['etc'],
            'model': item['model'],
            'mem': item['mem'],
            'status': item['status'],
            'price': item['price'],
          });
        }
      }
      return result;
    } else {
      List<Map<String, dynamic>> result = [];
      return result;
    }
  } catch(e) {
    print(e);
    List<Map<String, dynamic>> result = [];
    return result;
  }
}

/// 기기정보 가져오기
/// no 없으면 전체조회 (중복제거)
Future<List<Map<String, dynamic>>> getMachineInfo(String pcNo) async {
  print('$ServerUrl/getMachineInfo?no=${pcNo.toUpperCase()}');
  try {
    final response = await http.get('$ServerUrl/getMachineInfo?no=${pcNo.toUpperCase()}' as Uri).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
      ApiResult machineListResult = ApiResult.fromJson(json.decode(response.body));

      List<Map<String, dynamic>> result = [];
      List<Map<String, dynamic>> pcData = [];
      List<Map<String, dynamic>> userData = [];

      if(machineListResult.errCode == null) {
        if (pcNo == "") {
          for(int i=0; i<machineListResult.result!.length; i++) {
            Map<String, dynamic> item = machineListResult.result?[i];
            result.add({
              'no': item['no'],
              'userIdx': item['userIdx'],
              'name': item['name'],
              'usedate': item['usedate'],
              'returndate': item['returndate'],
              'userEtc': item['userEtc'],
              'idx': item['idx'],
              'cpu': item['cpu'],
              'ssd1': item['ssd1'],
              'ssd2': item['ssd2'],
              'ssd3': item['ssd3'],
              'hdd1': item['hdd1'],
              'hdd2': item['hdd2'],
              'hdd3': item['hdd3'],
              'os': item['os'],
              'vga': item['vga'],
              'fromdate': item['fromdate'],
              'updatedate': item['updatedate'],
              'location': item['location'],
              'model': item['model'],
              'mem': item['mem'],
              'status': item['status'],
              'price': item['price'],
              'etc': item['etc'],
            });
          }
        } else {
          for(int i=0; i<machineListResult.result!.length; i++) {
            Map<String, dynamic> item = machineListResult.result?[i];
            pcData.add({
              'idx': item['idx'],
              'no': item['no'],
              'cpu': item['cpu'],
              'ssd1': item['ssd1'],
              'ssd2': item['ssd2'],
              'ssd3': item['ssd3'],
              'hdd1': item['hdd1'],
              'hdd2': item['hdd2'],
              'hdd3': item['hdd3'],
              'os': item['os'],
              'vga': item['vga'],
              'fromdate': item['fromdate'],
              'updatedate': item['updatedate'],
              'location': item['location'],
              'model': item['model'],
              'mem': item['mem'],
              'status': item['status'],
              'price': item['price'],
              'etc': item['etc'],
            });

            userData.add({
              'userIdx': item['userIdx'],
              'no': item['no'],
              'name': item['name'],
              'usedate': item['usedate'],
              'returndate': item['returndate'],
              'userEtc': item['userEtc'],
            });
          }

          result.add({
            'pcData': pcData,
            'userData': userData
          });
        }
      }
      return result;
    } else {
      List<Map<String, dynamic>> result = [];
      return result;
    }
  } catch(e) {
    print(e);
    List<Map<String, dynamic>> result = [];
    return result;
  }
}

/// 해당 기기 사용자 히스토리 [사용X]
Future<List<Map<String, dynamic>>> getUserListPC(String no) async {
  print('$ServerUrl/getUserList?no=$no');
  try{
    final response = await http.get('$ServerUrl/getUserList?no=$no' as Uri).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
      ApiResult machineListResult = ApiResult.fromJson(json.decode(response.body));
      List<Map<String, dynamic>> result = [];
      if(machineListResult.errCode == null) {
        for(int i=0; i<machineListResult.result!.length; i++) {
          Map<String, dynamic> item = machineListResult.result?[i];
          result.add({
            'idx': item['idx'],
            'no': item['no'],
            'name': item['name'],
            'usedate': item['usedate'],
            'returndate': item['returndate'],
            'etc': item['etc'],
          });
        }
      }
      return result;
    } else {
      List<Map<String, dynamic>> result = [];
      return result;
    }
  } catch(e) {
    print(e);
    List<Map<String, dynamic>> result = [];
    return result;
  }
}

/// 해당 사용자의 기기리스트
/// all : true 중복포함 전체조회
/// all : false 중복제거
Future<List<Map<String, dynamic>>> getUserListUser(String name, bool all) async {
  print('$ServerUrl/getUserList?name=$name');
  try{
    final response = await http.get('$ServerUrl/getUserList?name=$name' as Uri).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
      ApiResult machineListResult = ApiResult.fromJson(json.decode(response.body));
      List<Map<String, dynamic>> result = [];
      List<String> id = [];
      if(machineListResult.errCode == null) {
        if (all) {
          for(int i=0; i<machineListResult.result!.length; i++) {
            Map<String, dynamic> item = machineListResult.result?[i];
            result.add({
              'idx': item['idx'],
              'no': item['no'],
              'name': item['name'],
              'usedate': item['usedate'],
              'returndate': item['returndate'],
              'etc': item['etc'],
            });
          }
        } else {
          List<Map<String, dynamic>> list = [];
          for(int i = machineListResult.result!.length; i > 0; i--) {
            Map<String, dynamic> item = machineListResult.result?[i-1];
            if (!id.contains(item['no'])) {
              id.add(item['no']);
              list.add({
                'idx': item['idx'],
                'no': item['no'],
                'name': item['name'],
                'usedate': item['usedate'],
                'returndate': item['returndate'],
                'etc': item['etc'],
              });
            }
          }
          result = deviceSort(list);
        }
      }
      return result;
    } else {
      List<Map<String, dynamic>> result = [];
      return result;
    }
  } catch(e) {
    print(e);
    List<Map<String, dynamic>> result = [];
    return result;
  }
}

/// 자산리스트 조회
/// all : true 중복포함 전체조회
/// all : false 중복제거
Future<List<Map<String, dynamic>>> getAssetList(bool all) async {
  print('$ServerUrl/assetList');
  try{
    var url = Uri.parse('$ServerUrl/assetList');
    final response = await http.get(url).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
      ApiResult machineListResult = ApiResult.fromJson(json.decode(response.body));
      List<Map<String, dynamic>> result = [];
      List<String> id = [];
      if(machineListResult.errCode == null) {
        if (all) {
          for(int i=0; i<machineListResult.result!.length; i++) {
            Map<String, dynamic> item = machineListResult.result?[i];
            result.add({
              'no': item['no'],
              'm_type': item['m_type'],
              'm_model': item['m_model'],
              'm_os': item['m_os'],
              'm_user': item['m_user'],
              'purchase_date': item['purchase_date'],
              'update_time': item['update_time'],
              'm_place': item['m_place'],
              'etc': item['etc'],
              'status': item['status'],
            });
          }
        } else {
          List<Map<String, dynamic>> list = [];
          for(int i = machineListResult.result!.length; i > 0; i--) {
            Map<String, dynamic> item = machineListResult.result?[i-1];
            if (!id.contains(item['no'])) {
              id.add(item['no']);
              list.add({
                'no': item['no'],
                'm_user': item['m_user'],
              });
            }
          }
          result = deviceSort(list);
        }
      }
      return result;
    } else {
      List<Map<String, dynamic>> result = [];
      return result;
    }
  } catch(e) {
    print(e);
    List<Map<String, dynamic>> result = [];
    return result;
  }
}

/// 로그인정보 조회
Future<List<Map<String, dynamic>>> getLogin(String id, String pw) async {
  print('$ServerUrl/loginService?id=$id&pw=$pw');
  try{
    final response = await http.get('$ServerUrl/loginService?id=$id&pw=$pw' as Uri).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
      ApiResult machineListResult = ApiResult.fromJson(json.decode(response.body));
      List<Map<String, dynamic>> result = [];
      if(machineListResult.errCode == null) {
        if (machineListResult.result!.length > 0) {
          Map<String, dynamic> item = machineListResult.result?[0];
          result.add({
            'id': item['id'],
            'pw': item['pw']
          });
          return result;
        }
      }
      return result;
    } else {
      List<Map<String, dynamic>> result = [];
      return result;
    }
  } catch(e) {
    print(e);
    List<Map<String, dynamic>> result = [];
    return result;
  }
}



/// //////////////////////////////////저장성 통신(PUT, POST)///////////////////////////////////////////////

/// /////////////// 기기 등록 /////////////////
Future<bool> postSetMachine(String no, String cpu, String ssd1, String ssd2, String ssd3, String hdd1, String hdd2, String hdd3,
    String os, String vga, String fromDate, String updateDate, String location, String etc, String model, String mem, String status, String price) async {
  print('$ServerUrl/setMachine');
  try{
    final response = await http.post('$ServerUrl/setMachine' as Uri,
      body:jsonEncode(<String, String>{
        'no':  no,
        'cpu': cpu,
        'ssd1': ssd1,
        'ssd2': ssd2,
        'ssd3': ssd3,
        'hdd1': hdd1,
        'hdd2': hdd2,
        'hdd3': hdd3,
        'os' : os,
        'vga': vga,
        'fromdate': fromDate,
        'updatedate': updateDate,
        'location':  location,
        'etc': etc,
        'model': model,
        'mem': mem,
        'status': status,
        'price': price
      }),
      headers: {'Content-Type': "application/json"},
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
      ApiResult machineListResult = ApiResult.fromJson(json.decode(response.body));
      if(machineListResult.errCode == null) {
        return true;
      } else {
        return false;
      }
    } else {
      // 만약 요청이 실패하면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  } catch(e) {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

/// /////////////// 기기 자산 추가 /////////////////
Future<bool> postAddAsset(String no, String type, String model, String os, String user, String puchaseDate, String place, String etc) async {
  print('$ServerUrl/addAsset');
  try{
    var url = Uri.parse('$ServerUrl/addAsset');
    // final response = await http.post(url).timeout(const Duration(seconds: 5));
    final response = await http.post(url,
        body:jsonEncode(<String, String>{
          'no':  no,
          'm_type': type,
          'm_model': model,
          'm_os': os,
          'm_user': user,
          'puchase_date': puchaseDate,
          'm_place': place,
          'etc': etc,
        }),
        headers: {'Content-Type': "application/json"},
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
      ApiResult machineListResult = ApiResult.fromJson(json.decode(response.body));
      if(machineListResult.errCode == null) {
        return true;
      } else {
        return false;
      }
    } else {
      // 만약 요청이 실패하면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  } catch(e) {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

/// /////////////// 기기 자산 수정 /////////////////
Future<bool> postUpdateAsset(String no, String type, String model, String os, String user, String purchaseDate, String place, String etc, String status) async {
  print('$ServerUrl/updateAsset');
  try{
    var url = Uri.parse('$ServerUrl/updateAsset');
    // final response = await http.post(url).timeout(const Duration(seconds: 5));
    final response = await http.post(url,
      body: jsonEncode({
        'no':  no,
        'm_type': type,
        'm_model': model,
        'm_os': os,
        'm_user': user,
        'purchase_date': purchaseDate,
        'm_place': place,
        'etc': etc,
        'status': status,
      }),
      headers: {'Content-Type': "application/json"},
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
      ApiResult machineListResult = ApiResult.fromJson(json.decode(response.body));
      if(machineListResult.errCode == null) {
        return true;
      } else {
        return false;
      }
    } else {
      // 만약 요청이 실패하면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  } catch(e) {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

/// /////////////// 기기 편집 ///////////////// [사용X]
Future<bool> postUpdateMachine(int idx, String no, String cpu, String ssd1, String ssd2, String ssd3, String hdd1, String hdd2, String hdd3,
    String os, String vga, String fromDate, String updateDate, String location, String etc, String model, String mem, String status, String price) async {
  print('$ServerUrl/updateMachine');
  try{
    final response = await http.post('$ServerUrl/updateMachine' as Uri,
      body: jsonEncode({
        'idx': idx,
        'no':  no,
        'cpu': cpu,
        'ssd1': ssd1,
        'ssd2': ssd2,
        'ssd3': ssd3,
        'hdd1': hdd1,
        'hdd2': hdd2,
        'hdd3': hdd3,
        'os' : os,
        'vga': vga,
        'fromdate': fromDate,
        'updatedate': updateDate,
        'location':  location,
        'etc': etc,
        'model': model,
        'mem': mem,
        'status': status,
        'price': price
      }),
      headers: {'Content-Type': "application/json"},
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
      ApiResult machineListResult = ApiResult.fromJson(json.decode(response.body));
      if(machineListResult.errCode == null) {
        return true;
      } else {
        return false;
      }
    } else {
      // 만약 요청이 실패하면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  } catch(e) {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

/// /////////////// 사용자 등록 /////////////////
Future<bool> postSetUser(String no, String name, String useDate, String returnDate, String etc) async {
  print('$ServerUrl/setUser');
  try{
    final response = await http.put('$ServerUrl/setUser' as Uri,
      body:jsonEncode(<String, String>{
        'no': no,
        'name': name,
        'usedate': useDate,
        'returndate': returnDate,
        'etc': etc,
      }),
      headers: {'Content-Type': "application/json"},
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
      ApiResult machineListResult = ApiResult.fromJson(json.decode(response.body));
      if(machineListResult.errCode == null) {
        return true;
      } else {
        return false;
      }
    } else {
      // 만약 요청이 실패하면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  } catch(e) {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

/// /////////////// 사용자 편집 ///////////////// [사용X]
Future<bool> postUpdateUser(int idx, String no, String name, String usedate, String returndate, String etc) async {
  print('$ServerUrl/updateUser');
  try{
    final response = await http.put('$ServerUrl/updateUser' as Uri,
      body: jsonEncode({
        'idx': idx,
        'no': no,
        'name': name,
        'usedate': usedate,
        'returndate': returndate,
        'etc': etc
      }),
      headers: {'Content-Type': "application/json"},
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
      ApiResult machineListResult = ApiResult.fromJson(json.decode(response.body));
      if(machineListResult.errCode == null) {
        return true;
      } else {
        return false;
      }
    } else {
      // 만약 요청이 실패하면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  } catch(e) {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}