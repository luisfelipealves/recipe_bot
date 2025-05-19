import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import '../models/instruction_model.dart';

// Lista de receitas mock
final List<Recipe> mockRecipes = [
  Recipe(
    id: '1',
    title: 'Spaghetti Carbonara Clássico',
    description: 'Uma receita tradicional italiana de spaghetti carbonara, rica e saborosa.',
    cookingTimeMinutes: 20,
    imageUrl: 'https://images.unsplash.com/photo-1588013273468-315088ea3426?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ingredients: [
      Ingredient(order: 1, name: 'Spaghetti', quantity: '200g'),
      Ingredient(
          order: 2, name: 'Guanciale ou Pancetta', quantity: '100g, em cubos'),
      Ingredient(
          order: 3, name: 'Ovos Frescos', quantity: '2 gemas + 1 ovo inteiro'),
      Ingredient(order: 4,
          name: 'Queijo Pecorino Romano',
          quantity: '50g, ralado fino'),
      Ingredient(order: 5,
          name: 'Pimenta do Reino Preta',
          quantity: 'A gosto, moída na hora'),
      Ingredient(order: 6, name: 'Sal', quantity: 'A gosto'),
    ],
    instructions: [
      Instruction(order: 1,
          description: 'Cozinhe o spaghetti conforme as instruções da embalagem até ficar al dente.'),
      Instruction(order: 2,
          description: 'Enquanto o macarrão cozinha, frite o guanciale/pancetta em uma frigideira grande até ficar crocante. Retire da frigideira e reserve a gordura.'),
      Instruction(order: 3,
          description: 'Em uma tigela, bata as gemas e o ovo inteiro com o queijo Pecorino ralado e uma boa quantidade de pimenta do reino moída.'),
      Instruction(order: 4,
          description: 'Escorra o macarrão, reservando um pouco da água do cozimento.'),
      Instruction(order: 5,
          description: 'Adicione o macarrão escorrido à frigideira com a gordura do guanciale. Misture bem.'),
      Instruction(order: 6,
          description: 'Retire a frigideira do fogo. Adicione rapidamente a mistura de ovos e queijo, mexendo vigorosamente para criar um molho cremoso. Se necessário, adicione um pouco da água do cozimento reservada para atingir a consistência desejada.'),
      Instruction(order: 7,
          description: 'Adicione o guanciale/pancetta crocante, misture e sirva imediatamente com mais queijo ralado e pimenta do reino por cima.'),
    ],
  ),
  Recipe(
    id: '2',
    title: 'Salada Caesar com Frango Grelhado',
    description: 'Uma salada Caesar refrescante e completa com pedaços de frango grelhado suculento.',
    cookingTimeMinutes: 30,
    imageUrl: 'https://images.unsplash.com/photo-1550304935-f2c06d390a8a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ingredients: [
      Ingredient(
          order: 1, name: 'Peito de Frango', quantity: '1 unidade grande'),
      Ingredient(
          order: 2, name: 'Alface Romana', quantity: '1 pé grande, rasgado'),
      Ingredient(order: 3, name: 'Croutons', quantity: '1 xícara'),
      Ingredient(
          order: 4, name: 'Queijo Parmesão Ralado', quantity: '1/4 xícara'),
      Ingredient(order: 5, name: 'Para o Molho Caesar:', quantity: ''),
      // Subtítulo
      Ingredient(order: 6, name: '  Maionese', quantity: '1/2 xícara'),
      Ingredient(
          order: 7, name: '  Suco de Limão', quantity: '2 colheres de sopa'),
      Ingredient(
          order: 8, name: '  Mostarda Dijon', quantity: '1 colher de chá'),
      Ingredient(order: 9, name: '  Alho', quantity: '1 dente, picado'),
      Ingredient(
          order: 10, name: '  Molho Inglês', quantity: '1 colher de chá'),
      Ingredient(order: 11,
          name: '  Azeite Extra Virgem',
          quantity: '2 colheres de sopa'),
      Ingredient(
          order: 12, name: '  Sal e Pimenta do Reino', quantity: 'A gosto'),
    ],
    instructions: [
      Instruction(order: 1,
          description: 'Tempere o peito de frango com sal, pimenta e um fio de azeite. Grelhe em uma frigideira ou churrasqueira até estar cozido por completo. Deixe descansar e depois corte em fatias ou cubos.'),
      Instruction(order: 2,
          description: 'Para o molho Caesar: Em uma tigela pequena, misture a maionese, suco de limão, mostarda Dijon, alho picado, molho inglês e azeite. Tempere com sal e pimenta do reino a gosto. Misture bem até ficar homogêneo.'),
      Instruction(order: 3,
          description: 'Em uma saladeira grande, coloque a alface romana rasgada.'),
      Instruction(
          order: 4, description: 'Adicione o frango grelhado sobre a alface.'),
      Instruction(order: 5, description: 'Regue com o molho Caesar preparado.'),
      Instruction(order: 6,
          description: 'Adicione os croutons e o queijo parmesão ralado por cima.'),
      Instruction(order: 7,
          description: 'Misture delicadamente para combinar todos os ingredientes ou sirva com os componentes separados para cada um montar o seu prato. Sirva imediatamente.'),
    ],
  ),
  Recipe(
    id: '3',
    title: 'Panquecas Americanas Fofas',
    description: 'Receita fácil para panquecas americanas clássicas, perfeitas para o café da manhã.',
    cookingTimeMinutes: 15,
    imageUrl: 'https://plus.unsplash.com/premium_photo-1670402001290-87611e32e140?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    // Adicionei um URL de exemplo
    ingredients: [
      Ingredient(
          order: 1, name: 'Farinha de Trigo', quantity: '1 e 1/2 xícaras'),
      Ingredient(order: 2, name: 'Açúcar', quantity: '2 colheres de sopa'),
      Ingredient(
          order: 3, name: 'Fermento em Pó', quantity: '2 colheres de chá'),
      Ingredient(order: 4, name: 'Sal', quantity: '1/2 colher de chá'),
      Ingredient(order: 5, name: 'Leite', quantity: '1 e 1/4 xícaras'),
      Ingredient(order: 6, name: 'Ovo', quantity: '1 unidade'),
      Ingredient(
          order: 7, name: 'Manteiga Derretida', quantity: '2 colheres de sopa'),
      Ingredient(order: 8,
          name: 'Extrato de Baunilha (opcional)',
          quantity: '1 colher de chá'),
    ],
    instructions: [
      Instruction(order: 1,
          description: 'Em uma tigela grande, misture a farinha, o açúcar, o fermento em pó e o sal.'),
      Instruction(order: 2,
          description: 'Em outra tigela, misture o leite, o ovo levemente batido e a manteiga derretida (e o extrato de baunilha, se estiver usando).'),
      Instruction(order: 3,
          description: 'Despeje os ingredientes líquidos sobre os ingredientes secos e misture apenas até combinar. Não misture demais; alguns grumos são normais e ajudam a manter as panquecas fofas.'),
      Instruction(order: 4,
          description: 'Aqueça uma frigideira ou chapa levemente untada em fogo médio.'),
      Instruction(order: 5,
          description: 'Para cada panqueca, despeje aproximadamente 1/4 de xícara de massa na frigideira quente.'),
      Instruction(order: 6,
          description: 'Cozinhe por cerca de 2-3 minutos de cada lado, ou até dourar e bolhas aparecerem na superfície.'),
      Instruction(order: 7,
          description: 'Sirva quente com suas coberturas favoritas, como maple syrup, frutas frescas, manteiga ou chantilly.'),
    ],
  ),
  // Adicione mais receitas mock aqui conforme necessário, cada uma com sua lista de ingredients e instructions
];