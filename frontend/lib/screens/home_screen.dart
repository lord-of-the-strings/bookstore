import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../models/category.dart';
import '../providers/book_provider.dart';
import 'book_detail_screen.dart';
import 'dart:async';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final booksAsync = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
  title: const Text(
    'The Book Nook',
    style: TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {},
    ),
    Consumer(
      builder: (context, ref, _) {
        final count = ref.watch(cartCountProvider);
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
            ),
            if (count > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    ),
  ],
),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category tabs
          categoriesAsync.when(
            data: (cats) => _CategoryBar(categories: cats),
            loading: () => const SizedBox(
              height: 56,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => const SizedBox.shrink(),
          ),

          //Search bar
          const _SearchBar(),

          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Browse our collection',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.5),
                letterSpacing: 1.2,
              ),
            ),
          ),

          // Book grid
          Expanded(
            child: booksAsync.when(
              data: (books) => books.isEmpty
                  ? const Center(child: Text('No books found.'))
                  : _BookGrid(books: books),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Category bar ──────────────────────────────────────────────
class _CategoryBar extends ConsumerWidget {
  final List<Category> categories;
  const _CategoryBar({required this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);
    final primary = Theme.of(context).colorScheme.primary;
    final surfaceVariant = Theme.of(context).colorScheme.surfaceVariant;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 36,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _Chip(
              label: 'All',
              isSelected: selected == null,
              selectedColor: primary,
              unselectedColor: surfaceVariant,
              onTap: () =>
                  ref.read(selectedCategoryProvider.notifier).state = null,
            ),
            ...categories.map((cat) => _Chip(
                  label: cat.name,
                  isSelected: selected == cat.slug,
                  selectedColor: primary,
                  unselectedColor: surfaceVariant,
                  onTap: () => ref
                      .read(selectedCategoryProvider.notifier)
                      .state = cat.slug,
                )),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : unselectedColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight:
                isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

// ── Book grid ─────────────────────────────────────────────────
class _BookGrid extends StatelessWidget {
  final List<Book> books;
  const _BookGrid({required this.books});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: books.length,
      itemBuilder: (_, i) => _BookCard(book: books[i]),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;
  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailScreen(bookId: book.id),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  book.coverUrl != null
                      ? Image.network(
                          book.coverUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _PlaceholderCover(),
                        )
                      : _PlaceholderCover(),
                  // Category badge overlay
                  if (book.categoryName != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: scheme.primary.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          book.categoryName!,
                          style: TextStyle(
                            color: scheme.onPrimary,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Info
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          book.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: scheme.onSurface.withOpacity(0.55),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$${book.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: scheme.primary,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 48,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
        ),
      ),
    );
  }
}

class _SearchBar extends ConsumerStatefulWidget {
  const _SearchBar();

  @override
  ConsumerState<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<_SearchBar> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchQueryProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        decoration: InputDecoration(
          hintText: 'Search by title or author...',
          prefixIcon: Icon(Icons.search, color: scheme.primary),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    ref.read(searchQueryProvider.notifier).state = '';
                  },
                )
              : null,
          filled: true,
          fillColor: scheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
