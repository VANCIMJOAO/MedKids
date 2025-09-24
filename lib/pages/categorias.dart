import 'package:flutter/material.dart';
import 'antibioticos_page.dart';
import 'anticonvulsivantes_page.dart';
import 'antiflamatorios_page.dart';
import 'antifungicos_page.dart';
import 'antihistaminicos_page.dart';
import 'antiparasitarios_page.dart';
import 'broncodilatadores_page.dart';

// ... Importe os outros componentes de página necessários ...

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final List<String> categorias = [
    "ANTIBIÓTICOS",
    "ANTI-CONVULSIVANTES",
    "ANTI-INFLAMATÓRIOS",
    "ANTI-FÚNGICOS",
    "ANTI-HISTAMÍNICOS",
    "ANTI-PARASITÁRIOS",
    "BRONCODILATADORES",
    "CORTICOSTERÓIDES",
    "LAXATIVOS",
    "SINTOMÁTICOS",
    "HIDRATAÇÃO VENOSA",
  ];

  final Map<String, Widget Function(BuildContext)> rotasCategorias = {
    "ANTIBIÓTICOS": (context) => MedicamentosPage(),
    "ANTI-CONVULSIVANTES": (context) => AnticonvulsivantesPage(),
    "ANTI-INFLAMATÓRIOS": (context) => AntiflamatorioPage(),
    "ANTI-FÚNGICOS": (context) => AntiFungicosPage(),
    "ANTI-HISTAMÍNICOS": (context) => AnthistaminicosPage(),
    "ANTI-PARASITÁRIOS": (context) => AntParasitariosPage(),
    "BRONCODILATADORES": (context) => BroncodilatadoresPage(),
    // ... Adicione as rotas para os outros componentes de página ...
  };

  final Map<String, IconData> iconesCategorias = {
    "ANTIBIÓTICOS": Icons.healing,
    "ANTI-CONVULSIVANTES": Icons.flash_on,
    "ANTI-INFLAMATÓRIOS": Icons.flare,
    "ANTI-FÚNGICOS": Icons.bug_report,
    "ANTI-HISTAMÍNICOS": Icons.bubble_chart,
    "ANTI-PARASITÁRIOS": Icons.bug_report,
    "BRONCODILATADORES": Icons.wb_sunny,
    // Adicione outros ícones conforme necessário
  };

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
    _searchController.addListener(_searchListener);
  }

  void _searchListener() {
    setState(() {
      categoriasFiltradas = categorias.where((categoria) =>
          categoria.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchListener);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = MediaQuery.of(context).size.width ~/ 150;
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
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: categoriasFiltradas.length,
                itemBuilder: (context, index) => CategoriaItem(
                  onTap: () {
                    final routeBuilder = rotasCategorias[categoriasFiltradas[index]];
                    if (routeBuilder != null) Navigator.push(context, MaterialPageRoute(builder: routeBuilder));
                  },
                  texto: categoriasFiltradas[index],
                  color: coresCategorias[categorias.indexOf(categoriasFiltradas[index])],
                  icone: iconesCategorias[categoriasFiltradas[index]]!, // Ícone
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriaItem extends StatelessWidget {
  final VoidCallback onTap;
  final String texto;
  final Color color;
  final IconData icone; // Novo Campo

  const CategoriaItem({
    Key? key,
    required this.onTap,
    required this.texto,
    required this.color,
    required this.icone, // Nova dependência
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white30,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, color: Colors.white), // Ícone
              Text(
                texto,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
