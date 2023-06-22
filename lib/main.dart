// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import, non_constant_identifier_names, unused_local_variable, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ip_info/color_schemes.g.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IP info',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var stts = "";
  var txtBtn = "Get your IP adress";
  bool isntGotIP = true;
  String ipInfoo = "";
  bool isReqInf = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("IP info")),
      ),
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: isntGotIP,
                        child: FilledButton(
                            onPressed: () async {
                              String icanhazip = "http://icanhazip.com/";
                              Response response =
                                  await get(Uri.parse(icanhazip));
                              setState(() {
                                stts = "Your IP address is: ${response.body}";
                                isntGotIP = !isntGotIP;
                                isReqInf = !isReqInf;
                              });
                            },
                            child: Text(txtBtn)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Visibility(
                          visible: !isReqInf,
                          child: Text(stts),
                        ),
                      ),
                      Visibility(
                        visible: !isReqInf,
                        child: FilledButton(
                          child: Text("Get IP info"),
                          onPressed: () async {
                            String icanhazip = "http://icanhazip.com/";
                            Response response = await get(Uri.parse(icanhazip));
                            String IPquery = response.body.replaceAll("\n", "");
                            String ipInfo =
                                "http://ip-api.com/json/$IPquery?fields=status,continent,country,regionName,city,lat,lon,timezone,isp,org,mobile,proxy,query";
                            get(Uri.parse(ipInfo)).then((Response res) {
                              // print(res.body);
                              Map<String, dynamic> respnseF =
                                  json.decode(res.body);
                              setState(() {
                                ipInfoo =
                                    "IP info for ${respnseF['query']}: \nContinent: ${respnseF['continent']}\ncountry: ${respnseF['country']}\nRegion: ${respnseF['regionName']}\ncity: ${respnseF['city']}\nlatitude: ${respnseF['lat']}\nLongtiude: ${respnseF['lon']}\nTimezone: ${respnseF['timezone']}\nISP: ${respnseF['isp']}\nOrginization: ${respnseF['org']}\n${respnseF["mobile"] ? "This connection is probably made via mobile network" : "This connection is made via wifi"}\n${respnseF['org']}\n${respnseF["proxy"] ? "This connection is made via VPN or proxy" : ""}";
                                isReqInf = !isReqInf;
                              });
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Center(
                          child: SelectableText(
                            ipInfoo,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("made by: "),
                        TextButton(
                            onPressed: () async {
                              final Uri myTg = Uri.parse("https://t.me/gop_g");
                              if (!await launchUrl(myTg,mode: LaunchMode.externalApplication)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("An error has occured")));
                              }
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "if the app doesnt launch please search for my account manually @gop_g")));
                            },
                            child: Text(
                              "@gop_g",
                            ))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
