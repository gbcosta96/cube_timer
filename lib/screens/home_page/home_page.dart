
import 'package:cube_timer/models/puzzle_config.dart';
import 'package:cube_timer/screens/home_page/graph/graph_body.dart';
import 'package:cube_timer/screens/home_page/reports/reports_body.dart';
import 'package:cube_timer/screens/home_page/timer/timer_body.dart';
import 'package:cube_timer/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0; 
  String? _puzzle = "3x3";
  final GlobalKey<TimerBodyState> _myKey = GlobalKey();

  void updateFather() {
    setState(() {});
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: (_myKey.currentState?.isRunning?? false) ? null : AppBar(
        title: DropdownButton<String>(
          value: _puzzle,
          items: PuzzleConfig.getPuzzles.map<DropdownMenuItem<String>>((PuzzleConfig puzzle) {
            return DropdownMenuItem<String>(
              value: puzzle.name,
              child: Text(puzzle.name),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _puzzle = newValue;
              _myKey.currentState?.doScramble(cubeSize: PuzzleConfig.getPuzzles.firstWhere((element) => element.name == _puzzle).size);
            });
          },
        ),
      ),
      body: (_myKey.currentState?.isRunning?? false) ? 
        TimerBody(key: _myKey, puzzle: PuzzleConfig.getPuzzles.firstWhere((element) => element.name == _puzzle), updateFather: updateFather)
       : PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _currentIndex = page;
          });
        },
        children: [
          TimerBody(key: _myKey, puzzle: PuzzleConfig.getPuzzles.firstWhere((element) => element.name == _puzzle), updateFather: updateFather),
          ReportsBody(puzzle: PuzzleConfig.getPuzzles.firstWhere((element) => element.name == _puzzle)),
          GraphBody(puzzle: PuzzleConfig.getPuzzles.firstWhere((element) => element.name == _puzzle)), 
        ],
      ),
      bottomNavigationBar: (_myKey.currentState?.isRunning?? false) ? null : BottomNavigationBar(
        backgroundColor: AppColors.containerColor,
        unselectedItemColor: AppColors.fontLightColor,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.linear);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: "",
          ),
        ],
      ),
    );
  }
}
