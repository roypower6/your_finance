import 'package:flutter/material.dart';
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
  List<DictModel> _searchResults = [];
  bool _isLoading = false;

  // Function to handle search
  Future<void> _searchDict(String query) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    try {
      final results = await BokApiService().getDictResultList(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      // Handle error here (e.g., show a dialog)
    } finally {
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5F1),
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
                  SizedBox(
                    width: 3,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 18,
                      ),
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
              const SizedBox(
                height: 10,
              ),
              // Search bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "알고 싶은 경제 용어를 입력해 주세요!",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        _searchDict(_searchController.text); // Trigger search
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator()) // Loading state
                  : Expanded(
                      child: _searchResults.isEmpty
                          ? const Text("검색 결과가 없습니다.")
                          : ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final result = _searchResults[index];
                                return ListTile(
                                  title: Text(result.word),
                                  subtitle: Text(
                                    result.content,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () {
                                    // Navigate to explanation screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ExplanationScreen(
                                          word: result.word,
                                          content: result.content,
                                        ),
                                      ),
                                    );
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
