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
