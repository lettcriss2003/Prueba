//import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba/controls/servicio_back/RespuestaGenerica.dart';
import 'package:prueba/controls/utiles/Utiles.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:prueba/controls/servicio_back/RespuestaGenerica.dart';
import 'package:prueba/controls/utiles/Utiles.dart';

class Conexion {
  final String URL = "http://10.20.139.221:3041/api";
  final String URL_MEDIA = "http:10.20.139.221:3041/multimedia/";

  Future<RespuestaGenerica> solicitudGet(String recurso, bool token) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    if (token) {
      Utiles util = Utiles();
      String? tokenA = await util.getValue('token');
      _header = {
        'Content-Type': 'application/json',
        'news-token': tokenA.toString()
      };
    }
    final String _url = "$URL/$recurso";
    final uri = Uri.parse(_url);
    try {
      final response = await http.get(uri, headers: _header);
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return _response(404, "Recurso no encontrado", []);
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          return _response(mapa['code'], mapa['msg'], mapa['datos']);
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['datos']);
      }
    } catch (e) {
      return _response(500, "Error inesperado", []);
    }
  }

  Future<RespuestaGenerica> solicitudPost(
      String recurso, bool token, Map<dynamic, dynamic> mapa) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    if (token) {
      Utiles util = Utiles();
      String? tokenA = await util.getValue('token');
      _header = {
        'Content-Type': 'application/json',
        'news-token': tokenA.toString()
      };
    }
    final String _url = "$URL/$recurso";
    final uri = Uri.parse(_url);
    try {
      final response =
          await http.post(uri, headers: _header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return _response(404, "Recurso no encontrado", []);
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          return _response(mapa['code'], mapa['msg'], mapa['datos']);
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['datos']);
      }
    } catch (e) {
      return _response(500, "Error inesperado", []);
    }
  }

  RespuestaGenerica _response(int code, String msg, dynamic data) {
    var respuesta = RespuestaGenerica();
    respuesta.code = code;
    respuesta.datos = data;
    respuesta.msg = msg;
    return respuesta;
  }
}
