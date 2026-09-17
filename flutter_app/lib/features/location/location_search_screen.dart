import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_theme.dart';
import '../../core/models/weather_model.dart';
import '../../core/services/api_service.dart';
import '../../core/services/language_provider.dart';
import '../../core/services/location_provider.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<LocationResult> _results = [];
  bool _isSearching = false;
  String? _searchError;

  final ApiService _api = ApiService();

  Future<void> _search(String query) async {
    if (query.trim().length < 2) {
      setState(() => _results = []);
      return;
    }
    setState(() {
      _isSearching = true;
      _searchError = null;
    });
    final results = await _api.searchLocation(query.trim());
    setState(() {
      _isSearching = false;
      _results = results;
      if (results.isEmpty) {
        _searchError = 'No locations found. Try another name.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>().langCode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Location'),
        backgroundColor: AppTheme.primaryGreen,
      ),
      body: Column(
        children: [
          Container(
            color: AppTheme.primaryGreen,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter village, city or district...',
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _results = []);
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white24,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white, width: 1),
                ),
              ),
              onChanged: (val) {
                setState(() {});
                if (val.trim().length >= 2) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (_controller.text == val) _search(val);
                  });
                }
              },
            ),
          ),
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _searchError != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_off, size: 60, color: Colors.grey),
                            const SizedBox(height: 12),
                            Text(_searchError!,
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : _results.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search, size: 60, color: Colors.grey),
                                SizedBox(height: 12),
                                Text('Search your village or city',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: _results.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final loc = _results[index];
                              return Card(
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: AppTheme.backgroundLight,
                                    child: Text('📍', style: TextStyle(fontSize: 20)),
                                  ),
                                  title: Text(
                                    loc.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    [loc.district, loc.state, loc.country]
                                        .where((s) => s.isNotEmpty)
                                        .join(', '),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios,
                                      size: 16, color: Colors.grey),
                                  onTap: () async {
                                    await context
                                        .read<LocationProvider>()
                                        .selectLocation(loc, lang);
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
