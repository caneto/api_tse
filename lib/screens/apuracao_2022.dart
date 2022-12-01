import 'dart:convert';

import 'package:apuracao_2022/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Apuracao2022 extends StatefulWidget {
  const Apuracao2022({super.key});
  
  @override
  State<Apuracao2022> createState() => _Apuracao2022State();
}

class _Apuracao2022State extends State<Apuracao2022> {
  List<User> usersList = [];

  Future getUserData() async {
    var response = await http.get(Uri.parse(
        'https://resultados.tse.jus.br/oficial/ele2022/544/dados-simplificados/br/br-c0001-e000544-r.json'));
    var jsonData = jsonDecode(response.body);

    for (var request in jsonData["cand"]) {
      User user = User(
          name: request["nm"],
          namevice: request['nv'],
          cc:request['cc'],  // Champa
          st: request['st'],
          votes: request["vap"],
          percentage: request["pvap"]);
          
      usersList.add(user);
    }

    return usersList;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 16, 118, 252),
        title: const Text('Apuração de votos'),
        centerTitle: true,
      ),
      body: Card(
        child: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Text(
                  'Consultando API...',
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: usersList.length,
                itemBuilder: (context, i) {
                  var result = snapshot.data[i].percentage.toString().replaceAll(',', '.');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                         height: 2,
                      ),
                      const Text('Partidos/Turno', 
                           style: TextStyle(
                              color: Colors.black, 
                              fontSize: 15, 
                              fontWeight: FontWeight.w700),),
                      ListTile(
                        title: Text(snapshot.data[i].cc,
                            style: const TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Text(
                           snapshot.data[i].st,
                           style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                         height: 2,
                      ),
                      const Text('Votação',
                          style: TextStyle(
                              color: Colors.blue, 
                              fontSize: 15, 
                              fontWeight: FontWeight.w700),
                            ),
                      ListTile(
                        title: Text(snapshot.data[i].name+'/'+snapshot.data[i].namevice,
                            style: const TextStyle(fontWeight: FontWeight.w400)),
                        subtitle: Text(
                           '${result} %',
                           style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text(snapshot.data[i].votes),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

//TO-DO: Instalar Intl e organizar o padrão pt-BR
