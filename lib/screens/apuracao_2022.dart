import 'dart:convert';

import 'package:apuracao_2022/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
          percentage: request["pvap"],
          votes: request["vap"]);
      usersList.add(user);
    }

    return usersList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 24, 24),
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
                  return ListTile(
                    title: Text(snapshot.data[i].name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${snapshot.data[i].percentage} %',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text(snapshot.data[i].votes),
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
