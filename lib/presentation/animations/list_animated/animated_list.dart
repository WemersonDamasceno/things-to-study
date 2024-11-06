import 'package:flutter/material.dart';

class AnimatedListScreen extends StatefulWidget {
  const AnimatedListScreen({super.key});

  @override
  State<AnimatedListScreen> createState() => _AnimatedListScreenState();
}

class _AnimatedListScreenState extends State<AnimatedListScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated List')),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _items.length,
              itemBuilder: (context, index, animation) {
                return _buildItem(_items[index], animation);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _addItem,
                child: const Text('Adicionar Item'),
              ),
              ElevatedButton(
                onPressed: _removeItem,
                child: const Text('Remover Item'),
              ),
            ],
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  // Constrói o item com animação de entrada pela direita
  Widget _buildItem(String item, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: ListTile(
        title: Text(item),
      ),
    );
  }

  // Função para adicionar item com animação
  void _addItem() {
    final int newIndex = _items.length;
    _items.add('Item ${newIndex + 1}');
    _listKey.currentState?.insertItem(
      newIndex,
      duration: const Duration(milliseconds: 500),
    );
  }

  // Função para remover item com animação
  void _removeItem() {
    if (_items.isNotEmpty) {
      final int index = _items.length - 1;
      final String removedItem = _items.removeAt(index);

      _listKey.currentState?.removeItem(
        index,
        (context, animation) => _buildItem(removedItem, animation),
        duration: const Duration(milliseconds: 500),
      );
    }
  }
}
