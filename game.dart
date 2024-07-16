import 'dart:io';
import 'dart:math';

const int size = 8;
const String empty = '.';
const String mark = '*';
const String black = 'X';
const String white = 'O';
String current = white;
String another = black;
bool gamecontrol = true;
int coin_white = 0;
int coin_black = 0;

void main() {
  Othello game = Othello();
  game.playgame();
}

class Othello {
  late List<List<String>> board;

  Othello() {
    board = List.generate(size, (_) => List.filled(size, empty));
    board[3][3] = white;
    board[3][4] = black;
    board[4][3] = black;
    board[4][4] = white;
    checkcoin();
  }
  void printBoard() {
    for (var row in board) {
      print(row.join(' '));
    }
  }

  void romovemark() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == mark) {
          board[i][j] = empty;
        }
      }
    }
  }

  void checkcoin() {
    coin_black = 0;
    coin_white = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == black) {
          coin_black += 1;
        } else if (board[i][j] == white) {
          coin_white += 1;
        }
      }
    }
  }

  bool wincon() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == mark) {
          return false;
        }
      }
    }
    return true;
  }

  void playgame() {
    while (true) {
      maker();
      printBoard();
      print('');
      print('O : $coin_white     X : $coin_black');
      print('');

      if (wincon()) {
        if (coin_white > coin_black) {
          print('Player O win');
        } else if (coin_white < coin_black) {
          print('Player X win');
        } else if (coin_white == coin_black) {
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
          row >= 8 ||
          col <= 0 ||
          col >= 8) {
        print('Invalid input');
        continue;
      }

      if (board[row - 1][col - 1] == mark) {
        board[row - 1][col - 1] = current;
        playing(row - 1, col - 1);
        romovemark();
      } else {
        print('Invalid move. Try again.');
      }
    }
  }

  void maker() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == another) {
          makertop(i, j);
          makerbottom(i, j);
          makerleft(i, j);
          makerright(i, j);
          makertopleft(i, j);
          makertopright(i, j);
          makerbottomleft(i, j);
          makerbottomright(i, j);
        }
      }
    }
  }

  void playing(row, col) {
    playtop(row, col);
    playbottom(row, col);
    playleft(row, col);
    playright(row, col);
    playtopleft(row, col);
    playtopright(row, col);
    playbottomleft(row, col);
    playbottomright(row, col);
    if (current == white) {
      current = black;
      another = white;
    } else if (current == black) {
      current = white;
      another = black;
    }
    checkcoin();
  }

  void makertop(int r, int c) {
    for (int nrow = r - 1; nrow >= 0; nrow--) {
      if (board[nrow][c] == empty || board[nrow][c] == mark) {
        break;
      } else if (board[nrow][c] == another) {
        continue;
      } else if (board[nrow][c] == current) {
        for (int irow = r + 1; irow < 8; irow++) {
          if (board[irow][c] == empty) {
            board[irow][c] = mark;
            break;
          } else if (board[irow][c] == mark) {
            break;
          } else if (board[irow][c] == current || board[irow][c] == mark) {
            break;
          } else if (board[irow][c] == another) {
            continue;
          }
        }
      }
    }
  }

  void makerbottom(int r, int c) {
    for (int nrow = r + 1; nrow < 8; nrow++) {
      if (board[nrow][c] == empty || board[nrow][c] == mark) {
        break;
      } else if (board[nrow][c] == another) {
        continue;
      } else if (board[nrow][c] == current) {
        for (int irow = r - 1; irow >= 0; irow--) {
          if (board[irow][c] == empty) {
            board[irow][c] = mark;
            break;
          } else if (board[irow][c] == mark) {
            break;
          } else if (board[irow][c] == current || board[irow][c] == mark) {
            break;
          } else if (board[irow][c] == another) {
            continue;
          }
        }
      }
    }
  }

  void makerleft(int r, int c) {
    for (int ncolumn = c - 1; ncolumn > -1; ncolumn--) {
      if (board[r][ncolumn] == empty || board[r][ncolumn] == mark) {
        break;
      } else if (board[r][ncolumn] == another) {
        continue;
      } else if (board[r][ncolumn] == current) {
        for (int icolumn = c + 1; icolumn < 8; icolumn++) {
          if (board[r][icolumn] == empty) {
            board[r][icolumn] = mark;
            break;
          } else if (board[r][icolumn] == mark) {
            break;
          } else if (board[r][icolumn] == current ||
              board[r][icolumn] == mark) {
            break;
          } else if (board[r][icolumn] == another) {
            continue;
          }
        }
      }
    }
  }

  void makerright(int r, int c) {
    for (int ncolumn = c + 1; ncolumn < 8; ncolumn++) {
      if (board[r][ncolumn] == empty || board[r][ncolumn] == mark) {
        break;
      } else if (board[r][ncolumn] == another) {
        continue;
      } else if (board[r][ncolumn] == current) {
        for (int icolumn = c - 1; icolumn > -1; icolumn--) {
          if (board[r][icolumn] == empty) {
            board[r][icolumn] = mark;
            break;
          } else if (board[r][icolumn] == mark) {
            break;
          } else if (board[r][icolumn] == current ||
              board[r][icolumn] == mark) {
            break;
          } else if (board[r][icolumn] == another) {
            continue;
          }
        }
      }
    }
  }

  void makertopleft(int r, int c) {
    for (int n = 1; n < min(r, c); n++) {
      if (board[r - n][c - n] == empty || board[r - n][c - n] == mark) {
        break;
      } else if (board[r - n][c - n] == another) {
        continue;
      } else if (board[r - n][c - n] == current) {
        for (int i = 1; i <= min(7 - r, 7 - c); i++) {
          if (board[r + i][c + i] == empty) {
            board[r + i][c + i] = mark;
            break;
          } else if (board[r + i][c + i] == mark) {
            break;
          } else if (board[r + i][c + i] == current ||
              board[r + i][c + i] == mark) {
            break;
          } else if (board[r + i][c + i] == another) {
            continue;
          }
        }
      }
    }
  }

  void makertopright(int r, int c) {
    for (int n = 1; n < min(r, 7 - c); n++) {
      if (board[r - n][c + n] == empty || board[r - n][c + n] == mark) {
        break;
      } else if (board[r - n][c + n] == another) {
        continue;
      } else if (board[r - n][c + n] == current) {
        for (int i = 1; i <= min(7 - r, c); i++) {
          if (board[r + i][c - i] == empty) {
            board[r + i][c - i] = mark;
            break;
          } else if (board[r + i][c - i] == mark) {
            break;
          } else if (board[r + i][c - i] == current ||
              board[r + i][c - i] == mark) {
            break;
          } else if (board[r + i][c - i] == another) {
            continue;
          }
        }
      }
    }
  }

  void makerbottomleft(int r, int c) {
    for (int n = 1; n < min(7 - r, c); n++) {
      if (board[r + n][c - n] == empty || board[r + n][c - n] == mark) {
        break;
      } else if (board[r + n][c - n] == another) {
        continue;
      } else if (board[r + n][c - n] == current) {
        for (int i = 1; i <= min(r, 7 - c); i++) {
          if (board[r - i][c + i] == empty) {
            board[r - i][c + i] = mark;
            break;
          } else if (board[r - i][c + i] == mark) {
            break;
          } else if (board[r - i][c + i] == current ||
              board[r - i][c + i] == mark) {
            break;
          } else if (board[r - i][c + i] == another) {
            continue;
          }
        }
      }
    }
  }

  void makerbottomright(int r, int c) {
    for (int n = 1; n < min(7 - r, 7 - c); n++) {
      if (board[r + n][c + n] == empty || board[r + n][c + n] == mark) {
        break;
      } else if (board[r + n][c + n] == another) {
        continue;
      } else if (board[r + n][c + n] == current) {
        for (int i = 1; i <= min(r, c); i++) {
          if (board[r - i][c - i] == empty) {
            board[r - i][c - i] = mark;
            break;
          } else if (board[r - i][c - i] == mark) {
            break;
          } else if (board[r - i][c - i] == current ||
              board[r - i][c - i] == mark) {
            break;
          } else if (board[r - i][c - i] == another) {
            continue;
          }
        }
      }
    }
  }

  //playyyyyyyyyyyyyyyyyyyyyyy

  void playtop(int r, int c) {
    List<List<int>> memory = [];
    for (int nrow = r - 1; nrow >= 0; nrow--) {
      if (board[nrow][c] == empty || board[nrow][c] == mark) {
        break;
      } else if (board[nrow][c] == another) {
        memory.add([nrow, c]);
        continue;
      } else if (board[nrow][c] == current) {
        for (var pos in memory) {
          board[pos[0]][pos[1]] = current;
        }
        break;
      }
    }
  }

  void playbottom(int r, int c) {
    List<List<int>> memory = [];
    for (int nrow = r + 1; nrow < 8; nrow++) {
      if (board[nrow][c] == empty || board[nrow][c] == mark) {
        break;
      } else if (board[nrow][c] == another) {
        memory.add([nrow, c]);
      } else if (board[nrow][c] == current) {
        for (var pos in memory) {
          board[pos[0]][pos[1]] = current;
        }
        break;
      }
    }
  }

  void playleft(int r, int c) {
    List<List<int>> memory = [];
    for (int ncolumn = c - 1; ncolumn >= 0; ncolumn--) {
      if (board[r][ncolumn] == empty || board[r][ncolumn] == mark) {
        break;
      } else if (board[r][ncolumn] == another) {
        memory.add([r, ncolumn]);
      } else if (board[r][ncolumn] == current) {
        for (var pos in memory) {
          board[pos[0]][pos[1]] = current;
        }
        break;
      }
    }
  }

  void playright(int r, int c) {
    List<List<int>> memory = [];
    for (int ncolumn = c + 1; ncolumn < 8; ncolumn++) {
      if (board[r][ncolumn] == empty || board[r][ncolumn] == mark) {
        break;
      } else if (board[r][ncolumn] == another) {
        memory.add([r, ncolumn]);
      } else if (board[r][ncolumn] == current) {
        for (var pos in memory) {
          board[pos[0]][pos[1]] = current;
        }
        break;
      }
    }
  }

  void playtopleft(int r, int c) {
    List<List<int>> memory = [];
    for (int n = 1; n < min(r, c); n++) {
      if (board[r - n][c - n] == empty || board[r - n][c - n] == mark) {
        break;
      } else if (board[r - n][c - n] == another) {
        memory.add([r - n, c - n]);
      } else if (board[r - n][c - n] == current) {
        for (var pos in memory) {
          board[pos[0]][pos[1]] = current;
        }
        break;
      }
    }
  }

  void playtopright(int r, int c) {
    List<List<int>> memory = [];

    for (int n = 1; n < min(r, 7 - c); n++) {
      if (board[r - n][c + n] == empty || board[r - n][c + n] == mark) {
        break;
      } else if (board[r - n][c + n] == another) {
        memory.add([r - n, c + n]);
      } else if (board[r - n][c + n] == current) {
        for (var pos in memory) {
          board[pos[0]][pos[1]] = current;
        }
        break;
      }
    }
  }

  void playbottomleft(int r, int c) {
    List<List<int>> memory = [];

    for (int n = 1; n < min(7 - r, c); n++) {
      if (board[r + n][c - n] == empty || board[r + n][c - n] == mark) {
        break;
      } else if (board[r + n][c - n] == another) {
        memory.add([r + n, c - n]);
      } else if (board[r + n][c - n] == current) {
        for (var pos in memory) {
          board[pos[0]][pos[1]] = current;
        }
        break;
      }
    }
  }

  void playbottomright(int r, int c) {
    List<List<int>> memory = [];

    for (int n = 1; n < min(7 - r, 7 - c); n++) {
      if (board[r + n][c + n] == empty || board[r + n][c + n] == mark) {
        break;
      } else if (board[r + n][c + n] == another) {
        memory.add([r + n, c + n]);
      } else if (board[r + n][c + n] == current) {
        for (var pos in memory) {
          board[pos[0]][pos[1]] = current;
        }
        break;
      }
    }
  }
}
