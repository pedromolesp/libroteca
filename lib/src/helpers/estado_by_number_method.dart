getEstadoByNumber(int number) {
  String message = "";
  switch (number) {
    case 0:
      message = "No disponible";
      break;
    case 1:
      message = "En posesión";
      break;
    case 2:
      message = "Prestado";
      break;
  }
  return message;
}
