// pdf_helpers.dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget textoEncabezado(String texto, {double? fontSize}) {
  return pw.Text(
    texto,
    style: pw.TextStyle(
      fontSize: fontSize ?? 8,
      fontWeight: pw.FontWeight.bold,
    ),
    textAlign: pw.TextAlign.center,
  );
}

pw.Widget textoNormal(String texto, {double? fontSize}) {
  return pw.Text(
    texto,
    style: pw.TextStyle(
      fontSize: fontSize ?? 12,
    ),
    textAlign: pw.TextAlign.center,
  );
}

pw.Widget textoNegrilla(
  String texto,
) {
  return pw.Text(
    texto,
    style: pw.TextStyle(
      fontSize: 10,
      fontWeight: pw.FontWeight.bold,
    ),
    textAlign: pw.TextAlign.center,
  );
}

pw.Widget textoNegrillaBox(String texto) {
  if (texto.toUpperCase().contains('APREHENDIDO')) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          texto,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(width: 5),
        pw.Container(
          width: 10,
          height: 10,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 1),
          ),
        ),
      ],
    );
  }

  return pw.Text(
    texto,
    style: pw.TextStyle(
      fontSize: 10,
      fontWeight: pw.FontWeight.bold,
    ),
    textAlign: pw.TextAlign.center,
  );
}


pw.Widget personaConCheckboxes() {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [
      // Texto "PERSONA:"
      pw.Text(
        '4: PERSONAS: ',
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      // Texto "APREHENDIDO" + cuadrado
      pw.Text(
        'APREHENDIDO ',
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.Container(
        width: 10,
        height: 10,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 1),
        ),
      ),
      pw.SizedBox(width: 10),
      // Texto "ARRESTADO" + cuadrado
      pw.Text(
        'ARRESTADO ',
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.Container(
        width: 10,
        height: 10,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 1),
        ),
      ),
    ],
  );
}


pw.Widget textoRecomendaciones(String texto) {
  return pw.Container(
    width: double.infinity,
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
    ),
    padding: const pw.EdgeInsets.all(8),
    child: pw.RichText(
      textAlign: pw.TextAlign.justify,
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: 'RECOMENDACIÓN: ',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.TextSpan(
            text: texto,
            style: const pw.TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}

pw.Widget textoCuadro(List<String> textos) {
  return pw.Container(
    width: double.infinity,
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
    ),
    padding: const pw.EdgeInsets.all(8),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < textos.length; i++)
          pw.Text(
            textos[i],
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.normal,
            ),
            textAlign: pw.TextAlign.justify,
          ),
      ],
    ),
  );
}

pw.Widget textoTitulo(String texto, {double? fontSize}) {
  return pw.Text(
    texto,
    style: pw.TextStyle(
      fontSize: fontSize ?? 16,
      fontWeight: pw.FontWeight.bold,
    ),
    textAlign: pw.TextAlign.center,
  );
}

pw.Widget textoSubrayado(String texto) {
  return pw.Container(
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(width: 0.5, color: PdfColors.black),
      ),
    ),
    padding: const pw.EdgeInsets.only(bottom: 1),
    child: pw.Text(
      texto,
      style: pw.TextStyle(
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.center,
    ),
  );
}
