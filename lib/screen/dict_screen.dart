import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:your_finance/model/dict_model.dart';
import 'package:your_finance/screen/dict_explanation_screen.dart';
import 'package:your_finance/service/bok_api.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DictModel> _searchHistory = [];
  List<DictModel>? _currentSearchResult;
  bool _isLoading = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  // 검색 이력 로드
  Future<void> _loadSearchHistory() async {
    prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('search_history') ?? [];
    setState(() {
      _searchHistory = historyJson
          .map((item) => DictModel.fromJson(json.decode(item)))
          .toList();
    });
  }

  // 검색 이력 저장
  Future<void> _saveSearchHistory(DictModel result) async {
    // 중복된 결과는 제거
    _searchHistory.removeWhere((item) => item.word == result.word);
    _searchHistory.insert(0, result);

    final historyJson =
        _searchHistory.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList('search_history', historyJson);
  }

  // 검색 이력 전체 삭제
  Future<void> _clearSearchHistory() async {
    setState(() {
      _searchHistory.clear();
    });
    await prefs.remove('search_history');
  }

  Future<void> _searchDict(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await BokApiService().getDictResultList(query);
      setState(() {
        if (results.isNotEmpty) {
          _currentSearchResult = results;
        } else {
          _currentSearchResult = null;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('검색 결과가 없습니다.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      });
    } catch (e) {
      setState(() {
        _currentSearchResult = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('검색 중 오류가 발생했습니다. 다시 시도해 주세요.'),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleItemClick(DictModel result) {
    // 사용자가 클릭한 항목만 검색 이력에 추가
    _saveSearchHistory(result);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExplanationScreen(
          word: result.word,
          content: result.content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "경제용어사전",
                    style: TextStyle(
                      color: Color(0xff5AA897),
                      fontWeight: FontWeight.bold,
                      fontSize: 33,
                    ),
                  ),
                  SizedBox(width: 3),
                  Column(
                    children: [
                      SizedBox(height: 18),
                      Text(
                        "with 한국은행",
                        style: TextStyle(
                          color: Color(0xff5AA897),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "알고 싶은 경제 용어를 입력해 주세요!",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        _searchDict(_searchController.text);
                      }
                    },
                  ),
                  prefixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _currentSearchResult = null;
                            });
                          },
                        )
                      : null,
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _searchDict(value);
                  }
                },
              ),
              const SizedBox(height: 15),
              if (_currentSearchResult == null && _searchHistory.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.history, color: Color(0xff5AA897)),
                          SizedBox(width: 8),
                          Text(
                            "검색 이력",
                            style: TextStyle(
                              color: Color(0xff5AA897),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Color(0xff5AA897)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("검색 이력 삭제"),
                                content: const Text("모든 검색 이력을 삭제하시겠습니까?"),
                                actions: [
                                  TextButton(
                                    child: const Text("취소"),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  TextButton(
                                    child: const Text("삭제"),
                                    onPressed: () {
                                      _clearSearchHistory();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _currentSearchResult?.length ??
                            _searchHistory.length,
                        itemBuilder: (context, index) {
                          final result = _currentSearchResult?[index] ??
                              _searchHistory[index];
                          return ListTile(
                            title: Text(
                              result.word,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              result.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            onTap: () {
                              _handleItemClick(result);
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
