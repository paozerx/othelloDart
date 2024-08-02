import 'dart:io';
import 'dart:math';

void main() {
  Board game = Board();
  game.playGameOutput();
}

class Board {
  late List<List<String>> board;
  int board_size = 8;
  String empty = '.';
  String mark = '*';
  String black = '○';
  String white = '●';
  String current = '●';
  String another = '○';
  int coinWhite = 0;
  int coinBlack = 0;
  List<int> botinfo = [];
  late Processing processor;
  Bot bot = Bot();

  Board() {
    board = List.generate(board_size, (_) => List.filled(board_size, empty));
    board[3][3] = white;
    board[3][4] = black;
    board[4][3] = black;
    board[4][4] = white;
    processor = Processing(board, board_size, mark, black, white, empty, this);
    processor.checkScore();
  }

  void initialize_board() {
    print('  ${List.generate(board_size, (i) => i + 1).join(' ')}');
    for (int i = 0; i < board_size; i++) {
      print('${i + 1} ${board[i].join(' ')}');
    }
  }

  void playGameOutput() {
    while (true) {
      markerValidMove();
      initialize_board();
      print('');
      print('●: $coinWhite     ○: $coinBlack');
      print('');

      if (processor.isGameOver()) {
        if (coinWhite > coinBlack) {
          print('Player ● win');
        } else if (coinWhite < coinBlack) {
          print('Player ○ win');
        } else {
          print('Draw');
        }
        break;
      }
      if (current == white) {
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
          playValid(row - 1, col - 1);
          processor.removeMark();
          processor.checkScore();
          processor.swapTurn();
        } else {
          print('Invalid move. Try again.');
        }
      } else if (current == black) {
        botinfo = bot.botPlay(board, mark) as List<int>;
        print('$current\'s turn. Enter row:');
        print(botinfo[0] + 1);
        print('$current\'s turn. Enter column:');
        print(botinfo[1] + 1);
        board[botinfo[0]][botinfo[1]] = current;
        playValid(botinfo[0], botinfo[1]);
        processor.removeMark();
        processor.checkScore();
        processor.swapTurn();
      }
    }
  }

  void markerValidMove() {
    for (int i = 0; i < board_size; i++) {
      for (int j = 0; j < board_size; j++) {
        if (board[i][j] == empty) {
          if (processor.canPlaceMarker(i, j, current, another)) {
            board[i][j] = mark;
          }
        }
      }
    }
  }

  void playValid(int row, int col) {
    processor.sendInfoPlay(row, col, current, another);
  }
}

class Processing {
  late List<List<String>> board;
  int board_size;
  String mark;
  String black;
  String white;
  String empty;
  Board game;
  final List<List<int>> directions = [
    [-1, 0],
    [1, 0],
    [0, -1],
    [0, 1],
    [-1, -1],
    [-1, 1],
    [1, -1],
    [1, 1],
  ];
  Processing(this.board, this.board_size, this.mark, this.black, this.white,
      this.empty, this.game);

  void swapTurn() {
    game.current = (game.current == white) ? black : white;
    game.another = (game.another == black) ? white : black;
  }

  void removeMark() {
    for (int i = 0; i < board_size; i++) {
      for (int j = 0; j < board_size; j++) {
        if (board[i][j] == mark) {
          board[i][j] = empty;
        }
      }
    }
  }

  bool isGameOver() {
    for (int i = 0; i < board_size; i++) {
      for (int j = 0; j < board_size; j++) {
        if (board[i][j] == mark) return false;
      }
    }
    return true;
  }

  void checkScore() {
    game.coinWhite = 0;
    game.coinBlack = 0;
    for (int i = 0; i < board_size; i++) {
      for (int j = 0; j < board_size; j++) {
        if (board[i][j] == black) game.coinBlack++;
        if (board[i][j] == white) game.coinWhite++;
      }
    }
  }

  bool canPlaceMarker(int row, int col, String current, String another) {
    for (var direction in directions) {
      if (canFlip(row, col, direction[0], direction[1], current, another)) {
        return true;
      }
    }
    return false;
  }

  bool canFlip(int r, int c, int dr, int dc, String current, String another) {
    int nr = r + dr;
    int nc = c + dc;
    bool hasOpponentBetween = false;

    while (nr >= 0 && nr < board_size && nc >= 0 && nc < board_size) {
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

  void sendInfoPlay(int row, int col, String current, String another) {
    for (var direction in directions) {
      playFlips(row, col, direction[0], direction[1], current, another);
    }
  }

  void playFlips(int r, int c, int dr, int dc, String current, String another) {
    List<List<int>> toFlip = [];
    int nr = r + dr;
    int nc = c + dc;

    while (nr >= 0 && nr < board_size && nc >= 0 && nc < board_size) {
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

class Bot {
  var random = Random();
  List botPlay(board, mark) {
    int row;
    int col;
    List<int> botplay = [];
    while (true) {
      row = random.nextInt(8);
      col = random.nextInt(8);
      if (board[row][col] == mark) {
        botplay.add(row);
        botplay.add(col);
        return botplay;
      }
    }
  }
}
