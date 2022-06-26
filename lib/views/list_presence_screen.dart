import 'package:alunos/models/pdf_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../utils/export.dart';

class ListPresenceScreen extends StatefulWidget {
  const ListPresenceScreen({Key? key}) : super(key: key);

  @override
  State<ListPresenceScreen> createState() => _ListPresenceScreenState();
}

class _ListPresenceScreenState extends State<ListPresenceScreen> {

  var _controllerStream = StreamController<QuerySnapshot>.broadcast();
  final _controllerSearch = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List _allResults = [];
  List _resultsList = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future? resultsLoaded;
  var listFirebase=[];
  List<CheckBoxModel> itens=[];
  var removeItems;

  _deleteItem(String id){
    db
        .collection('listHistory')
        .doc(id)
        .delete().then((value) => Navigator.pushReplacementNamed(context, "/list-presence"));
  }

  _data() async {
    var data = await db.collection("listHistory").get();

    setState(() {
      _allResults = data.docs;
    });
    resultSearchList();
    return "complete";
  }

  _search() {
    resultSearchList();
  }

  resultSearchList() {
    var showResults = [];

    if (_controllerSearch.text != "") {
      for (var items in _allResults) {
        var brands = RegisterModel.fromSnapshot(items,'school').doc.toLowerCase();

        if (brands.contains(_controllerSearch.text.toLowerCase())) {
          showResults.add(items);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  _createPdf(id)async{

    var splitted = id.split(' - ');

    var date   = splitted[0];
    var hour   = splitted[1];
    var classe = splitted[2];
    var period = splitted[3];
    var scholl = splitted[4];


    DocumentSnapshot snapshot = await db.collection("listHistory").doc(id).get();
    Map<String,dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    setState(() {
      listFirebase = data?["list"]??"";
      listFirebase.sort((a,b) => a.compareTo(b));
      //int i = 0;
      // for(i; i < listFirebase.length; i++){
      //   var splitted = listFirebase[i].toString().replaceAll("- ", '').split('#');
      //   var number = splitted[0];
      //   var name = splitted[1];
      //   var check = splitted[2];
      //   itens.insert(i,CheckBoxModel(texto: name,number: number,checked: check=='true'?true:false));
      //   listFirebase[i]==listFirebase[listFirebase.length==i?i-1:i]?listFirebase.removeAt(i):listFirebase.add(listFirebase[i]);
      //   print(itens[i].number);
      // }

      //removeItems = listFirebase.toSet().toList();
      //print(listFirebase);
    });

    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    PdfGrid grid = PdfGrid();

    grid.columns.add(count: 3);
    grid.headers.add(1);

    int i = 0;
    for(i; i < listFirebase.length; i++){
      var splitted = listFirebase[i].toString().replaceAll("- ", '').split('#');
      var number = splitted[0];
      var name = splitted[1];
      var check = splitted[2];

      itens.insert(i,CheckBoxModel(texto: name,number: number,checked: check=='true'?true:false));
      //listFirebase[i]==listFirebase[listFirebase.length==i?i-1:i]?listFirebase.removeAt(i):listFirebase.add(listFirebase[i]);
      itens[i].number==itens[listFirebase.length==i?i-1:i].number?listFirebase.removeAt(i):listFirebase.add(listFirebase[i]);
      print(listFirebase[i]);

      double line = 20.0*i+20;

      line.toInt();

      page.graphics.drawString('$number - $name',PdfStandardFont(PdfFontFamily.helvetica, 10),bounds: Rect.fromLTWH(0,line,500,50));
      page.graphics.drawString('Presença : ${check=='true'?'presente':'ausente'}',PdfStandardFont(PdfFontFamily.helvetica, 10),bounds: Rect.fromLTWH(400,line,700,50));
    }

    page.graphics.drawString('Dia : $date',PdfStandardFont(PdfFontFamily.helvetica, 10),bounds: Rect.fromLTWH(0,0,500,50));
    page.graphics.drawString('Horário : $hour',PdfStandardFont(PdfFontFamily.helvetica, 10),bounds: Rect.fromLTWH(100,0,400,50));
    page.graphics.drawString('Turma : $classe',PdfStandardFont(PdfFontFamily.helvetica, 10),bounds: Rect.fromLTWH(180,0,400,50));
    page.graphics.drawString('Período : $period',PdfStandardFont(PdfFontFamily.helvetica, 10),bounds: Rect.fromLTWH(260,0,500,50));
    page.graphics.drawString('Escola : $scholl',PdfStandardFont(PdfFontFamily.helvetica, 10),bounds: Rect.fromLTWH(360,0,600,50));

    List<int> bytes = document.save();
    document.dispose();

    saveAndLaunhFile(bytes, 'output.pdf');

  }

  @override
  void initState() {
    super.initState();
    _data();
    _controllerSearch.addListener(_search);
  }

  @override
  void dispose() {
    super.dispose();
    _controllerSearch.removeListener(_search);
    _controllerSearch.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = _search();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: PaletteColor.primaryColor,
        centerTitle: true,
        title: TextCustom(text: 'REGISTROS',size: 20,color: PaletteColor.white,),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: width*0.07),
                Input(
                  widthCustom: 0.7,
                  controller: _controllerSearch,
                  hint: 'Pesquisar',
                  icons: Icons.search,
                  colorIcon: PaletteColor.primaryColor,
                  sizeIcon: 25.0,
                  background: PaletteColor.white,
                  colorBorder: PaletteColor.greyBorder,
                )
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: height * 0.8,
              child: StreamBuilder(
                stream: _controllerStream.stream,
                builder: (context, snapshot) {

                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if(_resultsList.length == 0){
                        return Center(
                            child: TextCustom(text: 'Nenhuma registro salvo!',size: 20.0)
                        );
                      }else {
                        return ListView.builder(
                            itemCount: _resultsList.length,
                            itemBuilder: (BuildContext context, index) {
                              DocumentSnapshot item = _resultsList[index];

                              String id = item["id"];

                              return ItemList(
                                text: id,
                                onTapDelete: ()=>_deleteItem(id),
                                onTapEdit: ()=> Navigator.pushNamed(context, "/register-presence",arguments: id),
                                onPressedPDF: ()=>_createPdf(id),
                              );
                            });
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
