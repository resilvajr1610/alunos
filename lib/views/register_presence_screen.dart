import '../utils/export.dart';

class RegisterPresenceScreen extends StatefulWidget {
  final idClass;
  RegisterPresenceScreen({required this.idClass});

  @override
  State<RegisterPresenceScreen> createState() => _RegisterPresenceScreenState();
}

class _RegisterPresenceScreenState extends State<RegisterPresenceScreen> {

  var _controllerStream = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _controllerDate = TextEditingController();
  final _controllerStart = TextEditingController();
  final _controllerEnd = TextEditingController();
  var period = 'manhã';
  var scholl="";
  var classe="";
  var data="";
  final listPeriod = ['manhã', 'tarde', 'noite'];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var idClass="";
  var stream;
  var splitted;
  List splittedConvert=[];
  List<CheckBoxModel> itens=[];
  var allCheck = false;
  var listSave=[];
  var listFirebase=[];

  DropdownMenuItem<String>  buildMenuItem(String item)=>DropdownMenuItem(
    value: item,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextCustom(text: item,color: PaletteColor.greyText,),
    ),
  );

  _saveFirebase(){
    String id = _controllerDate.text.replaceAll("/", "-")+' - '+_controllerStart.text+' - '+classe+' - '+period+' - '+scholl;
    if(_controllerDate.text.isNotEmpty && _controllerDate.text.length == 10){
      if(_controllerStart.text.isNotEmpty && _controllerStart.text.length == 5){
        if(_controllerEnd.text.isNotEmpty && _controllerEnd.text.length == 5 && _controllerStart.text != _controllerEnd.text){

          db
              .collection("listHistory")
              .doc(id)
              .set({
                'id'      : id,
                'date'    : _controllerDate.text,
                'start'   : _controllerStart.text,
                'end'     : _controllerEnd.text,
                'school'  : scholl,
                'period'  : period,
                'class'   : classe,
                'time'    : DateTime.now(),
                'list'    : listSave
          }).then((value) => Navigator.pushReplacementNamed(context, "/home"));
        }else{
          showSnackBar(context, "Horário final está vazio", _scaffoldKey);
        }
      }else{
        showSnackBar(context, "Horário inicial está incorreto", _scaffoldKey);
      }
    }else{
      showSnackBar(context, "Data está incorreta", _scaffoldKey);
    }

  }

  void listPresence(){

    // List<CheckBoxModel> listTrue = List.from(itens.where((item) => item.checked));
    //
    // listTrue.forEach((item){
    //
    //   listSave.add(item.number+"#"+item.texto+"#"+item.checked.toString());
    //   //_saveFirebase(listSave);
    //   print(listSave);
    // });

    for (var items in itens) {
      listSave.add({'number':items.number,'student':items.texto, 'check':items.checked});
    }

    final Map<String, dynamic> profileMap = new Map();
    listSave.forEach((item) {
      profileMap[item['number']] = item;
    });
    listSave = profileMap.values.toList();

     print(listSave);

    // for(var i; i < itens.length; i++){
    //   listSave = itens;
    //   print(listSave);
    //   itens.insert(i,CheckBoxModel(texto: itens[i].texto,number: itens[i].number,checked: itens[i].checked));
    // }

    // listSave.add(itens[itens.length]);


  }

  _data() async {

    if(splittedConvert.length ==2 ){
      stream = db.collection("students").where('id',isEqualTo: splittedConvert[1]).snapshots();
      stream.listen((dados) {
        _controllerStream.add(dados);
      });

      var data = await db.collection("students").where('id', isEqualTo:  splittedConvert[1]).get();
      listFirebase  = data.docs;

    }else{
      DocumentSnapshot snapshot = await db.collection("listHistory").doc(splittedConvert[0]).get();
      Map<String,dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      setState(() {
        listFirebase = data?["list"]??"";
        int i = 0;

        for(i; i < listFirebase.length; i++){
          var splitted = listFirebase[i].toString().replaceAll("- ", '').split('#');
          var number = splitted[0];
          var name = splitted[1];
          var check = splitted[2];
          print(i);
          itens.insert(i,CheckBoxModel(texto: name,number: number,checked: check=='true'?true:false));
        }

      });
    }
  }

  @override
  void initState() {
    super.initState();
    var string = widget.idClass;
    splittedConvert = string.split("CREATE ");

    if(splittedConvert.length==1){
      splitted = splittedConvert[0].split(' - ');
      data =splitted[0];
      classe = splitted[2];
      period = splitted[3];
      scholl = splitted[4];
    }else{
      splitted = splittedConvert[1].split(' - ');
      classe = splitted[0];
      period = splitted[1];
      scholl = splitted[2];
    }
    _data();
  }
  @override
  void dispose() {
    super.dispose();
    _controllerStream.onCancel;
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
        title: TextCustom(text: 'REGISTRAR PRESENÇA',size: 20,color: PaletteColor.white,),
      ),
      body: Container(
        width: width,
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: width,
              margin: EdgeInsets.only(left: 10,top: 15),
              alignment: Alignment.centerLeft,
              child: TextCustom(text: 'Escola'),
            ),
            Container(
                height: 43,
                width: width,
                margin: EdgeInsets.only(left: 10,top: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: PaletteColor.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: PaletteColor.greyBorder)
                ),
                child: TextCustom(
                  text:  scholl,
                  color: PaletteColor.greyText,
                )
            ),
            Row(
              children: [
                Container(
                  width: width*0.3,
                  margin: EdgeInsets.only(left: 10,top: 15),
                  alignment: Alignment.centerLeft,
                  child: TextCustom(text: 'Turma'),
                ),
                Container(
                  width: width*0.4,
                  margin: EdgeInsets.only(left: 30,top: 15),
                  alignment: Alignment.centerLeft,
                  child: TextCustom(text: 'Período'),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 43,
                  width: width*0.3,
                  margin: EdgeInsets.only(left: 10,top: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: PaletteColor.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: PaletteColor.greyBorder)
                  ),
                  child: TextCustom(text: classe,color: PaletteColor.greyText,),
                ),
                Container(
                    height: 43,
                    width: width*0.3,
                    margin: EdgeInsets.only(left: 28,top: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: PaletteColor.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: PaletteColor.greyBorder)
                    ),
                    child: TextCustom(text: period,color: PaletteColor.greyText,),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: width*0.3,
                  margin: EdgeInsets.only(left: 10,top: 15),
                  alignment: Alignment.centerLeft,
                  child: TextCustom(text: 'Data'),
                ),
                Container(
                  width: width*0.4,
                  margin: EdgeInsets.only(left: 30,top: 15),
                  alignment: Alignment.centerLeft,
                  child: TextCustom(text: 'Horário'),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 0,top: 5),
                  alignment: Alignment.centerLeft,
                  child: Input(
                    widthCustom: 0.3,
                    controller: _controllerDate,
                    hint: '00/00/0000',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      DataInputFormatter(),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 0,top: 5),
                  alignment: Alignment.centerLeft,
                  child: Input(
                    widthCustom: 0.2,
                    controller: _controllerStart,
                    hint: '00:00',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      HoraInputFormatter(),
                    ],
                  ),
                ),
                Container(
                  width: 10,
                  alignment: Alignment.centerLeft,
                  child: TextCustom(text: 'a'),
                ),
                Container(
                  padding: EdgeInsets.only(left: 0,top: 5),
                  alignment: Alignment.centerLeft,
                  child: Input(
                    widthCustom: 0.2,
                    controller: _controllerEnd,
                    hint: '00:00',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      HoraInputFormatter(),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: width,
              alignment: Alignment.center,
              child: TextCustom(text: 'Alunos',size: 16.0,fontWeight: FontWeight.bold,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextCustom(text: 'Nome do Aluno',size: 16.0,fontWeight: FontWeight.bold,color: PaletteColor.greyText,),
                  TextCustom(text: 'Presente',size: 16.0,fontWeight: FontWeight.bold,color: PaletteColor.greyText,),
                ],
              ),
            ),
            Container(
              height: height * 0.4,
              child: splittedConvert.length ==2
                  ?StreamBuilder(
                stream: _controllerStream.stream,
                builder: (context, snapshot) {

                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Container();
                    case ConnectionState.active:
                    case ConnectionState.done:

                    QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;

                      if(querySnapshot.docs.length == 0){
                        return Center(
                            child: TextCustom(text: 'Nenhuma aluno cadastrado!',size: 20.0)
                        );
                      }else {

                        return ListView.builder(
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (BuildContext context, index) {
                              List<DocumentSnapshot> items = querySnapshot.docs.toList();
                              DocumentSnapshot item = items[index];

                                int number = item["number"];
                                String convert;
                                if(number<10){
                                  convert = '0'+number.toString();
                                }else{
                                  convert = number.toString();
                                }
                                var i = 0;
                                for(i; i < querySnapshot.docs.length; i++){
                                  itens.insert(i,CheckBoxModel(texto: item['student'],number: convert));
                                }

                              return CheckboxWidget(item: itens[index]);
                            });
                      }
                  }
                },
              )
                  :ListView.builder(
                itemCount: itens.length,
                itemBuilder: (_, int index){
                  return CheckboxWidget(item: itens[index]);
                },
              ),
            ),
            ButtonCustom(
                onPressed: ()=>listPresence(),
                text: 'Finalizar'
            )
          ],
        ),
      ),
    );
  }
}
