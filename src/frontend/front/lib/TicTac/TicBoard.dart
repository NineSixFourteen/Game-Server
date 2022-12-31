// ignore_for_file: file_names

class Board {
  final List<int> board;
  final List<String> players;
  final int turn; 
  final int winner;
  final bool gameDone;

  const Board({
    required this.players,
    required this.board,
    required this.turn,
    required this.winner,
    required this.gameDone
  });

  List<int> getBoard(String state){
    List<int> board = state.codeUnits;
    for(int i = 0; i < board.length;i++){
      board[i] = board[i] - 48;
    }
    return board;
  }

  factory Board.fromJson(Map<String, dynamic> json) {
    List<int> board = List.from(json['state'].codeUnits);
    for(int i = 0; i < board.length;i++){
      board[i] = board[i] - 48;
    }
    List<String> strs = List.empty(growable: true);
    var x = json['players'];
    String s = "$x";
    s = s.substring(1, s.length - 1);
    s.split(",");
    for(var x in s.split(",")){
      strs.add("$x");
    }
    
    return Board(
      players: strs,
      board: board,
      turn: json['turn'],
      winner: json['winner'],
      gameDone: json['isGameDone']
    );
  }
}