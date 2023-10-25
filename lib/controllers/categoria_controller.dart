import 'package:get/get.dart';
import 'package:minhas_tarefas/models/categoria.dart';
import 'package:minhas_tarefas/utils/categoria_dao.dart';

class CategoriaController extends GetxController {
  RxList<Categoria> todasCategorias = RxList<Categoria>();
  RxList<Categoria> categoriasFiltradas = RxList<Categoria>();

  final CategoriaDAO categoriaDAO = CategoriaDAO();

  Future<List<Categoria>> carregarCategorias() async {
    Categoria categoriaVazia = Categoria(nome: '');
    todasCategorias.add(categoriaVazia);
    todasCategorias.addAll(await categoriaDAO.getAllCategorias());
    return todasCategorias;
  }

  criarCategoria(Categoria categoria) async {
    int idCategoria = await categoriaDAO.insertCategoria(categoria);
    categoria.id = idCategoria;
    todasCategorias.add(categoria);
  }
}
