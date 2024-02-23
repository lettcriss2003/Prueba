import 'dart:convert';
import 'dart:developer';
import 'package:prueba/controls/Conexion.dart';
import 'package:prueba/controls/servicio_back/RespuestaGenerica.dart';
//import 'package:noticias/controls/servicio_back/RespuestaGenerica.dart';
import 'package:prueba/controls/servicio_back/modelo/InicioSession.dart';
import 'package:http/http.dart' as http;

// no se llama a conexion, se encapsula datos sensibles 
class FacadeService {
  Conexion c = Conexion();
  Future<inicioSesionSW> inicioSesion (Map<String, String> mapa)async{

    Map<String, String> header = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    final String _url = c.URL + "/autenticar";
    final uri = Uri.parse(_url);

    inicioSesionSW isw = inicioSesionSW();
    try {
      final response =
          await http.post(uri, headers: header, body: jsonEncode(mapa));
      log(response.body);
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          isw.code = 404;
          isw.msg = "Page not found";
          isw.tag = "error";
          isw.datos = [];
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          isw.code = mapa['code'];
          isw.msg = mapa['msg'];
          isw.tag = mapa['tag'];
          isw.datos = mapa['datos'];
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        isw.code = mapa['code'];
        isw.msg = mapa['msg'];
        isw.tag = "OK! Inicio sesion correcto";
        isw.datos = mapa['datos'];
      }
    } catch (e) {
      isw.code = 500;
      isw.msg = "Internal error";
      isw.tag = "error";
      isw.datos = [];
    }
    return isw;
      
  }

  Future<RespuestaGenerica> registro(Map<String, String> mapa) async {
    Map<String, String> header = {'Content-Type': 'application/json'};

    final String url = '${c.URL}/registro';

    final uri = Uri.parse(url);
    RespuestaGenerica isws = RespuestaGenerica();
    print(mapa);
    try {
      final response =
          await http.post(uri, headers: header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 400) {
          isws.code = 404;
          isws.msg = 'Recurso No Encontrado';
          isws.datos = {};
          return isws;
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        isws.code = mapa['code'];
        isws.msg = mapa['msg'];
        isws.datos = mapa['data'];
        return isws;
      }
    } catch (e) {
      isws.code = 500;
      isws.msg = 'Error Inesperado';
      isws.datos = {};
      return isws;
    }
    return isws;
  }
  

  Future<RespuestaGenerica> verGuias() async {
    return await c.solicitudGet('/listado/nro_guia/', false);
  }
  }
