import 'dart:convert';
import 'dart:html';

Future<void> saveAndLaunhFile(List<int> bytes, String fileName) async{

  AnchorElement(href: 'data:aplication/octer-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
  ..setAttribute('download', fileName)..click();

}