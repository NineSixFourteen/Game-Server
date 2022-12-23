// ignore: file_names
class Board {
  final List<int> board;
  final int turn; 
  final int winner;
  final bool gameDone;

  const Board({
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
    return Board(
      board: board,
      turn: json['turn'],
      winner: json['winner'],
      gameDone: json['isGameDone']
    );
  }
}