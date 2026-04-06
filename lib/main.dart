import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ProfilePage(),
    StudyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Perfil"),
          BottomNavigationBarItem(
              icon: Icon(Icons.book), label: "Estudos"),
        ],
      ),
    );
  }
}

//
// ------------------ ABA 1 (PERFIL) ------------------
//

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),
      body: SingleChildScrollView( 
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 150,
                  color: Colors.blue,
                ),
                const Positioned(
                  bottom: -45,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('assets/foto.png'), 
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            const Text(
              "Mateus Balbino Cavalcante",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text("RA: 123456"),

            const SizedBox(height: 20),

            Row(
              children: const [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(child: Text("Foco")),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(child: Text("Disciplina")),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(child: Text("Código Limpo")),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

//
// ------------------ ABA 2 (LÓGICA) ------------------
//

class StudyPage extends StatefulWidget {
  const StudyPage({super.key});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  double totalHoras = 0;

  final TextEditingController techController =
      TextEditingController();
  final TextEditingController hoursController =
      TextEditingController();

  final List<Map<String, dynamic>> sessions = [];

  void registrarSessao() {
    String tech = techController.text;
    double? horas = double.tryParse(hoursController.text);

    if (tech.isEmpty || horas == null || horas <= 0) {
      return;
    }

    setState(() {
      totalHoras += horas;
      sessions.add({
        "tech": tech,
        "horas": horas,
      });

      techController.clear();
      hoursController.clear();
    });
  }

  @override
  void dispose() {
    techController.dispose();
    hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de Estudos")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text("Total de Horas"),
                    Text(
                      totalHoras.toString(),
                      style: const TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
            ),

            TextField(
              controller: techController,
              decoration:
                  const InputDecoration(labelText: "Tecnologia"),
            ),

            TextField(
              controller: hoursController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration:
                  const InputDecoration(labelText: "Horas"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: registrarSessao,
              child: const Text("Registrar Sessão"),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final item = sessions[index];

                  return Card(
                    child: ListTile(
                      title: Text(item["tech"]),
                      subtitle:
                          Text("${item['horas']} horas"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPage(
                              tech: item["tech"],
                              horas: item["horas"],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

//
// ------------------ DETALHE ------------------
//

class DetailPage extends StatelessWidget {
  final String tech;
  final double horas;

  const DetailPage({
    super.key,
    required this.tech,
    required this.horas,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Tecnologia: $tech",
              style: const TextStyle(fontSize: 20)),
          Text("Horas: $horas",
              style: const TextStyle(fontSize: 20)),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Voltar"),
          )
        ],
      ),
    );
  }
}