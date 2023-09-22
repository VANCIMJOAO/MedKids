import 'package:flutter/material.dart';
import 'antibioticos_page.dart';  // Importe as páginas necessárias aqui
import 'anticonvulsivantes_page.dart';

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final List<String> categorias = [
    "ANTIBIÓTICOS",
    "ANTI-CONVULSIVANTES", // Adicione a nova categoria
    "ANTI-INFLAMATÓRIOS",
    "ANTI-FÚNGICOS",
    "ANTI-HISTAMÍNICOS",
    "ANTI-PARASITÁRIOS",
    "BRONCODILATADORES",
    "CORTICOSTERÓIDES",
    "LAXATIVOS",
    "SINTOMÁTICOS",
    "HIDRATAÇÃO VENOSA"
  ];

  final List<Color> coresCategorias = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.yellow,
    Colors.teal,
    Colors.pink,
    Colors.lime,
    Colors.cyan,
  ];

  TextEditingController _searchController = TextEditingController();

  List<String> categoriasFiltradas = [];

  @override
  void initState() {
    super.initState();
    categoriasFiltradas = categorias;

    _searchController.addListener(() {
      setState(() {
        categoriasFiltradas = categorias
            .where((categoria) => categoria.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias de Medicamentos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: categoriasFiltradas.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      color: coresCategorias[categorias.indexOf(categoriasFiltradas[index])],
                      child: ListTile(
                        title: Text(categoriasFiltradas[index], style: TextStyle(color: Colors.white)),
                        onTap: () {
                          if (categoriasFiltradas[index] == "ANTIBIÓTICOS") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MedicamentosPage()));
                          } else if (categoriasFiltradas[index] == "ANTI-CONVULSIVANTES") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AnticonvulsivantesPage()));
                          }
                          // Adicione outros encaminhamentos conforme necessário
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
