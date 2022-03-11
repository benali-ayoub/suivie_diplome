import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:suivie_diplome/models/booleantype.dart';
import 'package:suivie_diplome/models/dipDbModel.dart';
import '../../theme.dart';
import 'etab_cpanel.dart';

class EditDiplomePage extends StatefulWidget {
  const EditDiplomePage(
      {required this.dipCne, required this.nomComplet, required this.saRole, required this.saNom, required this.saEmail});
  final String dipCne;
  final String nomComplet;
  final String saRole;
  final String saNom, saEmail;

  @override
  _EditDiplomePageState createState() => _EditDiplomePageState();
}

class _EditDiplomePageState extends State<EditDiplomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  DiplomeModel d1 = DiplomeModel(
      et_cne: "",
      dp_edition: false,
      dp_edition_cause: "",
      dp_etab_signa: false,
      dp_verification: false,
      dp_verification_cause: "",
      dp_presid_signa: false,
      dp_date_remis: "",
      dp_remis: false,
      dp_remis_cause: "",
      dp_date_edition: "",
      dp_date_verification: "");

  Future<void> getDipData(String cne) async {
    var connection = PostgresConnection.getDBconnection();
    try {
      await connection.open();
    } catch (e) {
      Flushbar(
        title: 'Error',
        message: e.toString(),
        duration: const Duration(seconds: 20),
        icon: const Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.red,
        ),
        margin: const EdgeInsets.all(8.0),
        borderRadius: BorderRadius.circular(8),
        flushbarStyle: FlushbarStyle.FLOATING,
      ).show(context);    }

    var result = await connection.query(
        "select et_cne, dp_edition, dp_edition_cause, dp_etab_signa, dp_date_edition, dp_verification, dp_verification_cause, dp_presid_signa, dp_date_verification,  dp_remis, dp_remis_cause, dp_date_remis from diplome WHERE et_cne = '$cne'");
    setState(() {
      d1.et_cne = result[0][0];
      d1.dp_edition = result[0][1];
      d1.dp_edition_cause = result[0][2];
      d1.dp_etab_signa = result[0][3];
      d1.dp_date_edition = result[0][4].toString();
      d1.dp_verification = result[0][5];
      d1.dp_verification_cause = result[0][6];
      d1.dp_presid_signa = result[0][7];
      d1.dp_date_verification = result[0][8].toString();
      d1.dp_remis = result[0][9];
      d1.dp_remis_cause = result[0][10];
      d1.dp_date_remis = result[0][11].toString();
    });

    await connection.close();
  }

  Future<void> saveDipData(String cne) async {
    DateTime now = DateTime.now();
    EasyLoading.show(status: 'Enregistrement en cours...');
    var connection = PostgresConnection.getDBconnection();
    try {
      await connection.open();
    } catch (e) {
      Flushbar(
        title: 'Error',
        message: e.toString(),
        duration: const Duration(seconds: 20),
        icon: const Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.red,
        ),
        margin: const EdgeInsets.all(8.0),
        borderRadius: BorderRadius.circular(8),
        flushbarStyle: FlushbarStyle.FLOATING,
      ).show(context);    }

    if (edVerRem == 0) {
      await connection.query(
          "update diplome set et_cne = '${d1.et_cne}', dp_edition = ${d1.dp_edition} , dp_edition_cause = '${d1.dp_edition_cause}', dp_etab_signa = ${d1.dp_etab_signa}, dp_date_edition = '${d1.dp_date_edition}', dp_verification = ${d1.dp_verification}, dp_verification_cause = '${d1.dp_verification_cause}', dp_presid_signa = ${d1.dp_presid_signa}, dp_date_verification = '${d1.dp_date_verification}',  dp_remis = ${d1.dp_remis}, dp_remis_cause = '${d1.dp_remis_cause}', dp_date_remis = '${d1.dp_date_remis}' where et_cne = '$cne'");
    } else if (edVerRem == 1) {
      await connection.query(
          "update diplome set et_cne = '${d1.et_cne}', dp_edition = ${d1.dp_edition} , dp_edition_cause = '${d1.dp_edition_cause}', dp_etab_signa = ${d1.dp_etab_signa}, dp_date_edition = '${DateTime(now.year, now.month, now.day)}', dp_verification = ${d1.dp_verification}, dp_verification_cause = '${d1.dp_verification_cause}', dp_presid_signa = ${d1.dp_presid_signa}, dp_date_verification = '${d1.dp_date_verification}',  dp_remis = ${d1.dp_remis}, dp_remis_cause = '${d1.dp_remis_cause}', dp_date_remis = '${d1.dp_date_remis}' where et_cne = '$cne'");
    } else if (edVerRem == 3) {
      await connection.query(
          "update diplome set et_cne = '${d1.et_cne}', dp_edition = ${d1.dp_edition} , dp_edition_cause = '${d1.dp_edition_cause}', dp_etab_signa = ${d1.dp_etab_signa}, dp_date_edition = '${d1.dp_date_edition}', dp_verification = ${d1.dp_verification}, dp_verification_cause = '${d1.dp_verification_cause}', dp_presid_signa = ${d1.dp_presid_signa}, dp_date_verification = '${d1.dp_date_verification}',  dp_remis = ${d1.dp_remis}, dp_remis_cause = '${d1.dp_remis_cause}', dp_date_remis = '${DateTime(now.year, now.month, now.day)}' where et_cne = '$cne'");
    }

    await connection.close();
    EasyLoading.showSuccess("L'enregistrement est complete!");
    EasyLoading.dismiss();
  }

  int edVerRem = 0;

  @override
  void initState() {
    // TODO: implement initState
    getDipData(widget.dipCne);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            FontAwesomeIcons.arrowAltCircleLeft,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: themeBackgroundColor,
      body: Stack(children: [
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    enabled: false,
                    readOnly: true,
                    controller: TextEditingController()
                      ..text = "${d1.et_cne} - ${widget.nomComplet}",
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        labelText: 'C.N.E - Nom Complet'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(width: 3, color: Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: Image.asset('images/est.png'),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              "Section pour l'etablissement",
                              style: GoogleFonts.balooBhaijaan(
                                  fontWeight: FontWeight.w500, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Text(
                                  "Diplome edité:",
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 8.0, bottom: 8.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: DropdownButton(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    value: d1.dp_edition.toString(),
                                    items: Boolian.boolianList
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.boolianValue.toString(),
                                            child: Text(e.boolianName),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: d1.dp_verification
                                        ? (String? val) {
                                            Flushbar(
                                              title:
                                                  "Cette action n'est plus possible",
                                              message:
                                                  "Le diplome est en train de verification",
                                              duration: const Duration(seconds: 3),
                                              icon: const Icon(
                                                Icons.info_outline,
                                                size: 28.0,
                                                color: Colors.red,
                                              ),
                                              margin: const EdgeInsets.all(8.0),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              flushbarStyle:
                                                  FlushbarStyle.FLOATING,
                                            ).show(context);
                                          }
                                        : (String? val) {
                                            setState(() {
                                              DateTime now =  DateTime.now();
                                              DateTime date =  DateTime(now.year, now.month, now.day);
                                              d1.dp_date_edition = date.toString();
                                              edVerRem = 1;
                                              d1.dp_edition =
                                                  val == "true" ? true : false;
                                            });
                                          },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = d1.dp_edition_cause,
                                onChanged: (e) {
                                  setState(() {
                                    d1.dp_edition_cause = e;
                                  });
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText:
                                        "La cause (S'il n'est pas edité)"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Text(
                                  "Signé par l'etablissement:",
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 8.0, bottom: 8.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: DropdownButton(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    value: d1.dp_etab_signa.toString(),
                                    items: Boolian.boolianList
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.boolianValue.toString(),
                                            child: Text(e.boolianName),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: d1.dp_verification
                                        ? (String? val) {
                                            Flushbar(
                                              title:
                                                  "Cette action n'est plus possible",
                                              message:
                                                  "Le diplome est en train de verification",
                                              duration: const Duration(seconds: 3),
                                              icon: const Icon(
                                                Icons.info_outline,
                                                size: 28.0,
                                                color: Colors.red,
                                              ),
                                              margin: const EdgeInsets.all(8.0),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              flushbarStyle:
                                                  FlushbarStyle.FLOATING,
                                            ).show(context);
                                          }
                                        : (String? val) {
                                            setState(() {
                                              d1.dp_edition_cause = "Le diplome est Edite";
                                              DateTime now = DateTime.now();
                                              DateTime date = DateTime(
                                                  now.year, now.month, now.day);
                                              d1.dp_date_edition =
                                                  date.toString();
                                              d1.dp_edition = true;
                                              edVerRem = 1;
                                              d1.dp_etab_signa =
                                                  val == "true" ? true : false;
                                            });
                                          },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: TextField(
                                enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = d1.dp_date_edition.split(" ")[0],
                                onChanged: (e) {},
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: "La date d'edition"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: Image.asset('images/sp.png'),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              "Section pour service deplome \npresidence",
                              style: GoogleFonts.balooBhaijaan(
                                  fontWeight: FontWeight.w500, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Text(
                                  'Le diplome est verifié:',
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 8.0, bottom: 8.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: DropdownButton(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    value: d1.dp_verification.toString(),
                                    items: Boolian.boolianList
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.boolianValue.toString(),
                                            child: Text(e.boolianName),
                                          ),
                                        )
                                        .toList(),
                                    // onChanged: (String? val) {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: TextField(
                                enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = d1.dp_verification_cause,
                                onChanged: (e) {
                                  setState(() {
                                    d1.dp_verification_cause = e;
                                  });
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText:
                                        "La cause (S'il n'est pas verifié)"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Text(
                                  'Signé par Mr. le President:',
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 8.0, bottom: 8.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: DropdownButton(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    value: d1.dp_presid_signa.toString(),
                                    items: Boolian.boolianList
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.boolianValue.toString(),
                                            child: Text(e.boolianName),
                                          ),
                                        )
                                        .toList(),
                                    // onChanged: (String? val) {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: TextField(
                                enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = d1.dp_date_verification.split(" ")[0],
                                onChanged: (e) {},
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: "La date de verification"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: Image.asset('images/student.png'),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              "Section pour l'etat de l'etudiant",
                              style: GoogleFonts.balooBhaijaan(
                                  fontWeight: FontWeight.w500, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Text(
                                  "Remis par l'étudiant:",
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 8.0, bottom: 8.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: DropdownButton(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    value: d1.dp_remis.toString(),
                                    items: Boolian.boolianList
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.boolianValue.toString(),
                                            child: Text(e.boolianName),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: d1.dp_presid_signa
                                        ? (String? val) {
                                            setState(() {
                                              DateTime now = DateTime.now();
                                              DateTime date = DateTime(
                                                  now.year, now.month, now.day);
                                              d1.dp_date_remis =
                                                  date.toString();
                                              edVerRem = 3;
                                              d1.dp_remis =
                                                  val == "true" ? true : false;
                                            });
                                          }
                                        : (String? val) {
                                            Flushbar(
                                              title: 'Error',
                                              message:
                                                  "Le diplome doit etre signe par le president!",
                                              duration: const Duration(seconds: 3),
                                              icon: const Icon(
                                                Icons.info_outline,
                                                size: 28.0,
                                                color: Colors.red,
                                              ),
                                              margin: const EdgeInsets.all(8.0),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              flushbarStyle:
                                                  FlushbarStyle.FLOATING,
                                            ).show(context);
                                          },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: TextField(
                                enabled: d1.dp_presid_signa,
                                readOnly: !d1.dp_presid_signa,
                                controller: TextEditingController()
                                  ..text = d1.dp_remis_cause,
                                onChanged: (e) {
                                  setState(() {
                                    d1.dp_remis_cause = e;
                                  });
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText:
                                        "La cause (S'il n'est pas remis)"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: TextField(
                                enabled: d1.dp_presid_signa,
                                readOnly: !d1.dp_presid_signa,
                                controller: TextEditingController()
                                  ..text = d1.dp_date_remis.split(" ")[0],
                                onChanged: (e) {},
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: "La date (S'il est remis)"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 150,
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 1,
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () {
                      saveDipData(widget.dipCne);
                      Navigator.pop(context);
                    },
                    color: primaryColor,
                    minWidth: double.infinity,
                    height: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: const Text(
                      'Enregistrer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return EtabDashboard(
                          saRole: widget.saRole,
                          saNom: widget.saNom, saEmail: widget.saEmail,
                        );
                      }));
                    },
                    color: Colors.white,
                    minWidth: double.infinity,
                    height: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      'Annuler',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}