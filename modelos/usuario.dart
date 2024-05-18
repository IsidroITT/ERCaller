class Usuario{
  String? key;
  UsuarioDatos? usuarioDatos;

  Usuario({
    this.key,
    this.usuarioDatos
  });
}

class UsuarioDatos{
  String? usuario;
  String? correo;
  String? telefono;
  String? password;

  UsuarioDatos({
    this.usuario,
    this.correo,
    this.telefono,
    this.password
  });

  UsuarioDatos.fromJSON(Map<dynamic, dynamic> json) {
    usuario = json["usuario"];
    correo = json["correo"];
    telefono = json["telefono"];
    password = json["contraseña"];
  }
}