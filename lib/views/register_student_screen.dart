import '../utils/export.dart';

class RegisterStudentScreen extends StatefulWidget {
  final idClass;
  RegisterStudentScreen({required this.idClass});

  @override
  State<RegisterStudentScreen> createState() => _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends State<RegisterStudentScreen> {

  var _controllerStream = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _controllerClass = TextEditingController();
  final _controllerItem = TextEditingController();
  final _controllerNumber = TextEditingController();
  RegisterModel _registerModel = RegisterModel();
  var selectedPeriod = 'manhã';
  var selectedScholl;
  final listPeriod = ['manhã', 'tarde', 'noite'];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var enable = true;
  var idClass="";
  var stream;
  var splitted;

  DropdownMenuItem<String>  buildMenuItem(String item)=>DropdownMenuItem(
    value: item,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextCustom(text: item,color: PaletteColor.greyText,),
    ),
  );

  _showDialog(String number, String item) {

    if(item==""){
      _controllerItem.clear();
      _controllerNumber.clear();
    }else{
      _controllerItem.text = item;
      _controllerNumber.text = number;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          double width = MediaQuery.of(context).size.width;
          return ShowDialogCustom(
            title: item==""?'Cadastrar Aluno':'Alterar Aluno',
            listContent: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      height: 30,
                      width: 300,
                      child: TextCustom(text: 'Número')
                  ),
                  Input(
                    obscure: false,
                    keyboardType: TextInputType.number,
                    controller: _controllerNumber,
                    hint: '00',
                    fonts: 20,
                    inputFormatters: [],
                  ),
                  Container(
                      height: 30,
                      width: 300,
                      child: TextCustom(text: 'Aluno')
                  ),
                  Input(
                    obscure: false,
                    keyboardType: TextInputType.text,
                    controller: _controllerItem,
                    hint: 'Nome do Aluno',
                    fonts: 20,
                    inputFormatters: [],
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ),
            list: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                width: width*0.22,
                height: 30,
                child: ButtonCustom(
                  onPressed: () => item==""?_saveFirebase():_updateItem(number,item,_controllerItem.text),
                  text: item==""?'Salvar':'Alterar',
                ),
              ),
              SizedBox(width: 20),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                width: width*0.22,
                height: 30,
                child: ButtonCustom(
                  onPressed: () => Navigator.pop(context),
                  text: 'Cancelar',
                  colorButton: PaletteColor.greyButtom,
                  colorBorder: PaletteColor.greyButtom,
                ),
              ),

            ],
          );
        });
  }

  _saveFirebase(){
    String id = _controllerClass.text + ' - '+selectedPeriod+' - '+selectedScholl;
    if(id != ""){
      if(_controllerItem.text.isNotEmpty){
        if(_controllerNumber.text.isNotEmpty && int.parse(_controllerNumber.text)>0 && int.parse(_controllerNumber.text)<99){

          db
              .collection("students")
              .doc(_controllerItem.text)
              .set({
            'id'      :id,
            'number'  :int.parse(_controllerNumber.text),
            'student' : _controllerItem.text,
            'school'  : selectedScholl,
            'period'  : selectedPeriod,
            'class'   : _controllerClass.text,
            'time'    : DateTime.now()
          }).then((value){
            db
                .collection("class")
                .doc(id)
                .collection(_controllerNumber.text)
                .doc(_controllerItem.text)
                .set({
              'id'      :id,
              'number'  :int.parse(_controllerNumber.text),
              'student' : _controllerItem.text,
              'school'  : selectedScholl,
              'period'  : selectedPeriod,
              'class'   : _controllerClass.text,
              'time'    : DateTime.now()

            }).then((value){
              db
                  .collection("classList")
                  .doc(id)
                  .set({
                'id'    :   id,
              }).then((value) {
                Navigator.pop(context);
                _controllerItem.clear();
                _controllerNumber.clear();
              });
            });
          });
        }else{
          showSnackBar(context, "Número do aluno está incorreto", _scaffoldKey);
        }
      }else{
        showSnackBar(context, "Nome do aluno está vazio", _scaffoldKey);
      }
    }else{
      print('erro');
    }

  }

  _updateItem(String number, String itemOld, String itemNew){

    String idNew;
    if(widget.idClass==""){
      idNew = _controllerClass.text + ' - '+selectedPeriod+' - '+selectedScholl;
    }else{
      idNew = widget.idClass;
      _controllerClass.text = splitted[0];
      selectedPeriod = splitted[1];
      selectedScholl = splitted[2];
    }

    if(_controllerItem.text.isNotEmpty) {
      if(_controllerClass.text.isNotEmpty){
        if(selectedScholl!=null){
          db
              .collection('students')
              .doc(itemOld)
              .delete().then((value){
            db
                .collection('class')
                .doc(idNew)
                .collection(number)
                .doc(itemOld)
                .delete().then((value) {
                db
                    .collection('students')
                    .doc(itemNew)
                    .set({
                  'id'      :idNew,
                  'number'  : int.parse(_controllerNumber.text),
                  'student' : itemNew,
                  'class'   : _controllerClass.text,
                  'period'  : selectedPeriod,
                  'school'  : selectedScholl,
                  'time'    : DateTime.now()
                }).then((value){
                    db
                        .collection("class")
                        .doc(idNew)
                        .collection(_controllerNumber.text)
                        .doc(itemNew)
                        .set({
                      'id'      :idNew,
                      'number'  :int.parse(_controllerNumber.text),
                      'student' : _controllerItem.text,
                      'school'  : selectedScholl,
                      'period'  : selectedPeriod,
                      'class'   : _controllerClass.text,
                      'time'    : DateTime.now()
                    });
                  }).then((value){
                    Navigator.pop(context);
                    _controllerNumber.clear();
                    _controllerItem.clear();
                  });
                });
              });

        }else{
          showSnackBar(context, "Selecione uma escola", _scaffoldKey);
        }
      }else{
        showSnackBar(context, "Nome da turma está vazio", _scaffoldKey);
      }
    }else{
        showSnackBar(context, "Nome do aluno está vazio", _scaffoldKey);
    }
  }

  _deleteItem(String number,String item){

    String idDelete;
    if(widget.idClass==""){
      idDelete = _controllerClass.text + ' - '+selectedPeriod+' - '+selectedScholl;
    }else{
      idDelete = widget.idClass;
    }

    db
        .collection('students')
        .doc(item)
        .delete().then((value){
      db
          .collection("class")
          .doc(idDelete)
          .collection(number)
          .doc(item)
          .delete();
      });
  }

  _data() async {
    if(widget.idClass!=""){
      stream = db.collection("students").where('id',isEqualTo: widget.idClass).snapshots();
      var string = widget.idClass;
      splitted = string.split(' - ');
      setState(() {
        enable=false;
      });
    }else{
      stream = db.collection("students").where('time',isGreaterThan:DateTime.now()).snapshots();
    }

    stream.listen((dados) {
      _controllerStream.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
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
        title: TextCustom(text: 'ALUNOS',size: 20,color: PaletteColor.white,),
      ),
      body: Container(
        width: width,
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
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
                  padding: EdgeInsets.only(left: 0,top: 5),
                  alignment: Alignment.centerLeft,
                  child: Input(
                    enable: enable,
                    widthCustom: 0.3,
                    controller: _controllerClass,
                    hint: widget.idClass==""?'Turma':splitted[0],
                  ),
                ),
                enable?Container(
                  height: 43,
                  width: width*0.3,
                  margin: EdgeInsets.only(left: 24,top: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: PaletteColor.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: PaletteColor.greyBorder)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      alignment: Alignment.center,
                      value: selectedPeriod,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12
                      ),
                      items: listPeriod.map(buildMenuItem).toList(),
                      onChanged: (value) => setState(() => selectedPeriod = value.toString()),
                    ),
                  ),
                ):Container(
                    height: 43,
                    width: width*0.3,
                    margin: EdgeInsets.only(left: 24,top: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: PaletteColor.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: PaletteColor.greyBorder)
                    ),
                    child: TextCustom(
                      text: widget.idClass==""?selectedPeriod:splitted[1],
                      color: PaletteColor.greyText,
                    )
                ),
              ],
            ),
            Container(
              width: width,
              margin: EdgeInsets.only(left: 10,top: 15),
              alignment: Alignment.centerLeft,
              child: TextCustom(text: 'Escola'),
            ),
            enable?Container(
              height: 43,
              width: width,
              margin: EdgeInsets.only(left: 10,top: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: PaletteColor.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: PaletteColor.greyBorder)
              ),
              child: DropdownButtonHideUnderline(
                child: StreamBuilder<QuerySnapshot>(
                  stream:FirebaseFirestore.instance.collection('schools').snapshots(),
                  builder: (context,snapshot){

                        if(!snapshot.hasData){
                          return Container();
                        }else {
                          List<DropdownMenuItem> espItems = [];
                          for (int i = 0; i < snapshot.data!.docs.length;i++){
                            DocumentSnapshot snap=snapshot.data!.docs[i];
                            espItems.add(
                                DropdownMenuItem(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: TextCustom(
                                      text:  snap.id,
                                      color: PaletteColor.greyText,
                                    ),
                                  ),
                                  value: "${snap.id}",
                                )
                            );
                          }
                          return DropdownButton<dynamic>(
                            isExpanded: true,
                            value: selectedScholl,
                            items: espItems,
                            onChanged: (value){
                              setState(() {
                                selectedScholl = value.toString();
                              });
                            },
                          );
                        }
                  },
                )
              )
            ):Container(
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
                  text: widget.idClass==""?selectedScholl:splitted[2],
                  color: PaletteColor.greyText,
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(),
                Container(
                  padding: EdgeInsets.all(20),
                  width: width*0.3,
                  alignment: Alignment.center,
                  child: TextCustom(text: 'Alunos',size: 16.0,fontWeight: FontWeight.bold,),
                ),
                AddButtom(onPressed: (){
                  if(widget.idClass!=""){
                    _controllerClass.text = splitted[0];
                    selectedPeriod = splitted[1];
                    selectedScholl = splitted[2];
                  }
                  if(_controllerClass.text.isNotEmpty){
                    if(selectedScholl!=null){
                      setState(() {
                        enable=false;
                      });
                      _showDialog('','');
                    }else{
                      showSnackBar(context, "Selecione a escola", _scaffoldKey);
                    }
                  }else{
                    showSnackBar(context, "Nome da turma está vazio", _scaffoldKey);
                  }
                }),
              ],
            ),
            Container(
              height: height * 0.5,
              child: StreamBuilder(
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

                              String number = item["number"].toString();
                              String student = item["student"];

                              return ItemList(
                                text: number+' - '+ student,
                                onTapDelete: ()=>_deleteItem(number,student),
                                onTapEdit: ()=>_showDialog(number,student),
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
