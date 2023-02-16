import 'package:flutter/material.dart';
import 'package:s4s_mobileapp/tools/functions.dart';

class SizeGuidePage extends StatefulWidget {
  const SizeGuidePage({Key? key}) : super(key: key);

  @override
  State<SizeGuidePage> createState() => _SizeGuidePageState();
}

class _SizeGuidePageState extends State<SizeGuidePage> {
  bool activeNike = false;
  bool activeAdidas = false;
  bool activeNB = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  iconSize: 25,
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/Home');
                  },
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Size Guide",
                  style: robotoStyle(FontWeight.w800,
                      const Color.fromARGB(255, 49, 48, 54), 20, null),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            color: Colors.grey,
            height: 0,
            thickness: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: ExpansionPanelList(
                          expansionCallback: (panelIndex, isExpanded) {
                            if (panelIndex == 0) {
                              setState(() {
                                activeNike = !activeNike;
                              });
                            } else if (panelIndex == 1) {
                              setState(() {
                                activeAdidas = !activeAdidas;
                              });
                            } else {
                              setState(() {
                                activeNB = !activeNB;
                              });
                            }
                          },
                          children: <ExpansionPanel>[
                            ExpansionPanel(
                                backgroundColor:
                                    const Color.fromARGB(255, 235, 235, 235),
                                headerBuilder: (context, isExpanded) {
                                  return Row(
                                    children: [
                                      Text(
                                        "   Nike & Jordan",
                                        style: robotoStyle(
                                            FontWeight.w900,
                                            activeNike
                                                ? const Color.fromARGB(
                                                    255, 255, 35, 35)
                                                : const Color.fromARGB(
                                                    255, 49, 48, 54),
                                            18,
                                            null),
                                      )
                                    ],
                                  );
                                },
                                body: Image.asset(
                                  // To be replaced by Brand Size Chart
                                  'assets/etc/splash-cropped.png',
                                  width: 250,
                                  height: 70,
                                ),
                                isExpanded: activeNike,
                                canTapOnHeader: true),
                            ExpansionPanel(
                                backgroundColor:
                                    const Color.fromARGB(255, 235, 235, 235),
                                headerBuilder: (context, isExpanded) {
                                  return Row(
                                    children: [
                                      Text(
                                        "   Adidas & Yeezy",
                                        style: robotoStyle(
                                            FontWeight.w900,
                                            activeAdidas
                                                ? const Color.fromARGB(
                                                    255, 255, 35, 35)
                                                : const Color.fromARGB(
                                                    255, 49, 48, 54),
                                            18,
                                            null),
                                      )
                                    ],
                                  );
                                },
                                body: Image.asset(
                                  'assets/etc/splash-cropped.png',
                                  width: 250,
                                  height: 70,
                                ),
                                isExpanded: activeAdidas,
                                canTapOnHeader: true),
                            ExpansionPanel(
                                backgroundColor:
                                    const Color.fromARGB(255, 235, 235, 235),
                                headerBuilder: (context, isExpanded) {
                                  return Row(
                                    children: [
                                      Text(
                                        "   New Balance",
                                        style: robotoStyle(
                                            FontWeight.w900,
                                            activeNB
                                                ? const Color.fromARGB(
                                                    255, 255, 35, 35)
                                                : const Color.fromARGB(
                                                    255, 49, 48, 54),
                                            18,
                                            null),
                                      )
                                    ],
                                  );
                                },
                                body: Image.asset(
                                  'assets/etc/splash-cropped.png',
                                  width: 250,
                                  height: 70,
                                ),
                                isExpanded: activeNB,
                                canTapOnHeader: true)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
