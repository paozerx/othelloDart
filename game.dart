import 'dart:io';

const int size = 8;
const String empty = '.';
const String mark = '*';
const String black = 'X';
const String white = 'O';
String current = white;
String another = black;
List<List<int>> directions = [
  [-1, 0],
  [1, 0],
  [0, -1],
  [0, 1],
  [-1, -1],
  [-1, 1],
  [1, -1],
  [1, 1],
];

void main() {
  Othello game = Othello();
  game.playGame();
}

class Othello {
  late List<List<String>> board;
  int coinWhite = 0;
  int coinBlack = 0;

  Othello() {
    board = List.generate(size, (_) => List.filled(size, empty));
    board[3][3] = white;
    board[3][4] = black;
    board[4][3] = black;
    board[4][4] = white;
    checkCoins();
  }

  void printBoard() {
    print('  ${List.generate(size, (i) => i + 1).join(' ')}');
    for (int i = 0; i < size; i++) {
      print('${i + 1} ${board[i].join(' ')}');
    }
  }

  void removeMark() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j] == mark) {
          board[i][j] = empty;
        }
      }
    }
  }

  void checkCoins() {
    coinWhite = 0;
    coinBlack = 0;
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j] == black) coinBlack++;
        if (board[i][j] == white) coinWhite++;
      }
    }
  }

  bool wincon() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j] == mark) return false;
      }
    }
    return true;
  }

  void playGame() {
    while (true) {
      maker();
      printBoard();
      print('');
      print('O: $coinWhite     X: $coinBlack');
      print('');

      if (wincon()) {
        if (coinWhite > coinBlack) {
          print('Player O wins');
        } else if (coinWhite < coinBlack) {
          print('Player X wins');
        } else {
          print('Draw');
        }
        break;
      }

      print('$current\'s turn. Enter row:');
      int? row = int.tryParse(stdin.readLineSync()!);
      print('$current\'s turn. Enter column:');
      int? col = int.tryParse(stdin.readLineSync()!);
      print('');
      if (row == null ||
          col == null ||
          row <= 0 ||
          row >= 9 ||
          col <= 0 ||
          col >= 9) {
        print('Invalid input');
        continue;
      }

      if (board[row - 1][col - 1] == mark) {
        board[row - 1][col - 1] = current;
        play(row - 1, col - 1);
        removeMark();
        checkCoins();
        current = (current == white) ? black : white;
        another = (another == black) ? white : black;
      } else {
        print('Invalid move. Try again.');
      }
    }
  }

  void maker() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j] == empty) {
          if (canPlaceMarker(i, j)) {
            board[i][j] = mark;
          }
        }
      }
    }
  }

  bool canPlaceMarker(int row, int col) {
    for (var direction in directions) {
      if (canFlip(row, col, direction[0], direction[1])) {
        return true;
      }
    }
    return false;
  }

  bool canFlip(int r, int c, int dr, int dc) {
    int nr = r + dr;
    int nc = c + dc;
    bool hasOpponentBetween = false;

    while (nr >= 0 && nr < size && nc >= 0 && nc < size) {
      if (board[nr][nc] == empty || board[nr][nc] == mark) return false;
      if (board[nr][nc] == another) {
        hasOpponentBetween = true;
      } else if (board[nr][nc] == current) {
        return hasOpponentBetween;
      }
      nr += dr;
      nc += dc;
    }
    return false;
  }

  void play(int row, int col) {
    for (var direction in directions) {
      flipcoins(row, col, direction[0], direction[1]);
    }
  }

  void flipcoins(int r, int c, int dr, int dc) {
    List<List<int>> toFlip = [];
    int nr = r + dr;
    int nc = c + dc;

    while (nr >= 0 && nr < size && nc >= 0 && nc < size) {
      if (board[nr][nc] == empty || board[nr][nc] == mark) {
        break;
      } else if (board[nr][nc] == another) {
        toFlip.add([nr, nc]);
      } else if (board[nr][nc] == current) {
        for (var pos in toFlip) {
          board[pos[0]][pos[1]] = current;
        }
        break;
      }
      nr += dr;
      nc += dc;
    }
  }
}
