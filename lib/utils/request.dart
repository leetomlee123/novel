import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:novel/config.dart';
import 'package:novel/global.dart';

/*
  * http 操作类
  *
  * 手册
  * https://github.com/flutterchina/dio/blob/master/README-ZH.md
  *
  * 从3.x升级到 4.x
  * https://github.com/flutterchina/dio/blob/master/migration_to_4.x.md
*/
class Request {
  static Request _instance = Request._internal();

  factory Request() => _instance;

  late Dio dio;
  late CookieJar cookieJar;
  CancelToken cancelToken = new CancelToken();

  Request._internal() {
    // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    BaseOptions options = new BaseOptions(
      // 请求基地址,可以包含子路径
      baseUrl: SERVER_API_URL,

      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 20000,

      // 响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 5000,

      // Http请求头.
      headers: {
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36 Edg/96.0.1054.62",
        "referer": "https://ting55.com/"
      },
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );

    dio = new Dio(options);
    cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print, // specify log function (optional)
      retries: 3, // retry count (optional)
      retryDelays: const [
        // set delays between retries (optional)
        Duration(seconds: 1), // wait 1 sec before first retry
        Duration(seconds: 2), // wait 2 sec before second retry
        Duration(seconds: 3), // wait 3 sec before third retry
      ],
    ));
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //   // config the http client
    //   client.findProxy = (uri) {
    //     //proxy all request to localhost:8888
    //     return 'PROXY 127.0.0.1:10809';
    //   };
    //   // you can also create a HttpClient to dio
    //   // return HttpClient();
    // };
    // 添加拦截器
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      // 在请求被发送之前做一些预处理
      return handler.next(options); //continue
    }, onResponse: (response, handler) {
      // 在返回响应数据之前做一些预处理
      return handler.next(response);
    }, onError: (DioError e, handler) {
      // 当请求失败时做一些预处理
      // ErrorEntity eInfo = createErrorEntity(e);
      // 错误提示
      // BotToast.showText(text:eInfo.message.toString());
      // 错误交互处理
      // switch (eInfo.code) {
      //   case 401: // 没有权限 重新登录
      //     // deleteTokenAndReLogin();
      //     break;
      //   default:
      // }
      return handler.reject(e);
    }));
  }

  /// 读取token
  Map<String, dynamic> getAuthorizationHeader() {
    var headers = {"": ""};
    String? token = Global.profile?.token;
    if (token != null) {
      headers = {
        'auth': '$token',
      };
    }
    return headers;
  }

  /// restful get 操作
  Future get(String path, {dynamic params, Options? options}) async {
    Options requestOptions = options ?? Options();

    Map<String, dynamic> _authorization = getAuthorizationHeader();
    if (_authorization.isNotEmpty) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }
    var response = await dio.get(path,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken);
    return response.data;
  }

  /// restful post 操作
  Future post(String path,
      {dynamic params, Options? options, bool? useToken = true}) async {
    Options requestOptions = options ?? Options();

    Map<String, dynamic> _authorization = getAuthorizationHeader();
    if (useToken! && _authorization.isNotEmpty) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }

    var response = await dio.post(path,
        data: params, options: requestOptions, cancelToken: cancelToken);
    return response.data;
  }

  /// restful put 操作
  Future put(String path, {dynamic params, Options? options}) async {
    Options requestOptions = options ?? Options();
    Map<String, dynamic> _authorization = getAuthorizationHeader();
    if (_authorization.isNotEmpty) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }
    var response = await dio.put(path,
        data: params, options: requestOptions, cancelToken: cancelToken);
    return response.data;
  }

  /// restful patch 操作
  Future patch(String path, {dynamic params, Options? options}) async {
    Options requestOptions = options ?? Options();

    Map<String, dynamic> _authorization = getAuthorizationHeader();
    if (_authorization.isNotEmpty) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }

    var response = await dio.patch(path,
        data: params, options: requestOptions, cancelToken: cancelToken);

    return response.data;
  }

  Future patchForm(String path, {dynamic params, Options? options}) async {
    Options requestOptions = options ?? Options();

    Map<String, dynamic> _authorization = getAuthorizationHeader();
    if (_authorization.isNotEmpty) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }

    var response = await dio.patch(path,
        data: FormData.fromMap(params),
        options: requestOptions,
        cancelToken: cancelToken);

    return response.data;
  }

  /// restful delete 操作
  Future delete(String path, {dynamic params, Options? options}) async {
    Options requestOptions = options ?? Options();

    Map<String, dynamic> _authorization = getAuthorizationHeader();
    if (_authorization.isNotEmpty) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }
    var response = await dio.delete(path,
        data: params, options: requestOptions, cancelToken: cancelToken);
    return response.data;
  }

  /// restful post form 表单提交操作
  Future postForm(String path,
      {dynamic params, Options? options, bool? useToken = true}) async {
    Options requestOptions = options ?? Options();

    Map<String, dynamic> _authorization = getAuthorizationHeader();

    if (useToken! && _authorization.isNotEmpty) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }
    var response = await dio.post(path,
        data: FormData.fromMap(params),
        options: requestOptions,
        cancelToken: cancelToken);
    return response.data;
  }

  Future<List<int>> getAsByte(
    String path,
  ) async {
    var response = await dio.get(path,
        options: Options(responseType: ResponseType.bytes),
        cancelToken: cancelToken);
    return response.data;
  }

  Future<List<int>> download(
    String path,
  ) async {
    var response = await dio.download(path, "",
        options: Options(responseType: ResponseType.bytes),
        cancelToken: cancelToken);
    return response.data;
  }

  /*
   * error统一处理
   */
  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        {
          return ErrorEntity(code: -1, message: "请求取消");
        }
      case DioErrorType.connectTimeout:
        {
          return ErrorEntity(code: -1, message: "连接超时");
        }
      case DioErrorType.sendTimeout:
        {
          return ErrorEntity(code: -1, message: "请求超时");
        }

      case DioErrorType.receiveTimeout:
        {
          return ErrorEntity(code: -1, message: "响应超时");
        }
      case DioErrorType.response:
        {
          try {
            int? errCode = error.response?.statusCode;
            if (errCode == null) {
              return ErrorEntity(code: -2, message: error.message);
            }
            switch (errCode) {
              case 400:
                {
                  return ErrorEntity(
                      code: errCode,
                      message: error.response?.data['message'] ?? "请求语法错误");
                }

              case 401:
                {
                  return ErrorEntity(
                      code: errCode,
                      message: error.response?.data['message'] ?? "没有权限");
                }

              case 403:
                {
                  return ErrorEntity(
                      code: errCode,
                      message: error.response?.data['message'] ?? "服务器拒绝执行");
                }
              case 404:
                {
                  return ErrorEntity(code: errCode, message: "无法连接服务器");
                }
              case 405:
                {
                  return ErrorEntity(
                      code: errCode,
                      message: error.response?.data['message'] ?? "请求方法被禁止");
                }
              case 500:
                {
                  return ErrorEntity(code: errCode, message: "服务器内部错误");
                }
              case 502:
                {
                  return ErrorEntity(code: errCode, message: "无效的请求");
                }
              case 503:
                {
                  return ErrorEntity(
                      code: errCode,
                      message: error.response?.data['message'] ?? "服务器挂了");
                }
              case 505:
                {
                  return ErrorEntity(
                      code: errCode,
                      message:
                          error.response?.data['message'] ?? "不支持HTTP协议请求");
                }
              default:
                {
                  return ErrorEntity(
                      code: errCode, message: error.response?.data['message']);
                }
            }
          } on Exception catch (_) {
            return ErrorEntity(code: -1, message: "未知错误");
          }
        }
      default:
        {
          return ErrorEntity(code: -1, message: error.message);
        }
    }
  }
}

// 异常处理
class ErrorEntity implements Exception {
  int code;
  String? message;

  ErrorEntity({required this.code, this.message});

  String toString() {
    if (message == null) return "Exception";
    return "Exception: code $code, $message";
  }
}
