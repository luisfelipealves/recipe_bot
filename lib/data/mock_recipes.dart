// lib/data/mock_recipes.dart
import '../models/recipe_model.dart';

final List<Recipe> mockRecipes = [
  Recipe(
    id: '1',
    title: 'Bolo de Cenoura com Cobertura de Chocolate',
    description: 'Um clássico bolo de cenoura fofinho com uma deliciosa cobertura de chocolate.',
    cookingTimeMinutes: 60,
    imageUrl: 'https://via.placeholder.com/150/FFC107/000000?Text=BoloCenoura',
  ),
  Recipe(
    id: '2',
    title: 'Macarrão ao Molho Pesto',
    description: 'Uma receita rápida e saborosa de macarrão com molho pesto caseiro.',
    cookingTimeMinutes: 20,
    imageUrl: 'https://via.placeholder.com/150/4CAF50/FFFFFF?Text=MacarraoPesto',
  ),
  Recipe(
    id: '3',
    title: 'Salmão Grelhado com Legumes',
    description: 'Uma opção saudável e elegante, perfeita para um jantar especial.',
    cookingTimeMinutes: 35,
    // imageUrl: null, // Ou simplesmente omita, pois é anulável
  ),
  Recipe(
    id: '4',
    title: 'Risoto de Cogumelos',
    description: 'Um risoto cremoso e reconfortante, ideal para dias mais frios.',
    cookingTimeMinutes: 45,
    imageUrl: 'https://via.placeholder.com/150/795548/FFFFFF?Text=RisotoCogumelos',
  ),
  Recipe(
    id: '5',
    title: 'Panquecas Americanas (Sem Imagem Exemplo)',
    description: 'Panquecas fofas e douradas, perfeitas para o café da manhã ou lanche.',
    cookingTimeMinutes: 25,
    // imageUrl não fornecido, será null
  ),
];