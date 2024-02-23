import 'package:prueba/controls/servicio_back/RespuestaGenrica.dart';

class inicioSesionSW extends RespuestaGenerica{
  String tag = '';
  inicioSesionSW({msg='', code=0, datos, this.tag=''});

}