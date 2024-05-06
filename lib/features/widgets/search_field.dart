import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gallery_app/features/widgets/suffix_icon_button.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key, required this.onSearch});

  final ValueChanged<String> onSearch;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _searchController;
  Timer? _debouncer;
  bool _showSuffixIconButton = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      controller: _searchController,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: "Search ...",
        prefixIcon: const Icon(Icons.search_outlined),
        suffixIcon: _showSuffixIconButton
            ? SuffixIconButton(
                onTap: () {
                  _searchController.clear();
                  _onSearchChanged('');
                },
                child: const Icon(Icons.clear),
              )
            : null,
      ),
    );
  }

  void _onSearchChanged(String text) {
    _updateSuffixIconButtonVisibility();
    _debouncer?.cancel();
    _debouncer = Timer(const Duration(milliseconds: 2000), () {
      widget.onSearch.call(text.trim());
    });
  }

  void _updateSuffixIconButtonVisibility() {
    if (_showSuffixIconButton && _searchController.text.isEmpty) {
      setState(() => _showSuffixIconButton = false);
    }

    if (!_showSuffixIconButton && _searchController.text.isNotEmpty) {
      setState(() => _showSuffixIconButton = true);
    }
  }
}
