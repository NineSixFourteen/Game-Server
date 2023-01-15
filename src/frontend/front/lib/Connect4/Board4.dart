// ignore_for_file: file_names

class Board4 {
  final int id;
  final List<List<int>> board;
  final List<String> players;
  final List<int> photos;
  final int turn; 
  final int winner;
  final bool gameDone;

  const Board4({
    required this.id,
    required this.players,
    required this.board,
    required this.turn,
    required this.winner,
    required this.gameDone,
    required this.photos
  });

  factory Board4.fromJson(Map<String, dynamic> json,int id) {
    List<int> chars = List.from(json['state'].codeUnits);
    List<List<int>> board = List.generate(7, (_) => List.generate(7, (_) => 0));
    for(int i = 0; i < 7;i++){
      for(int j = 0;j < 7;j++){
        board[6 - i][j] = chars[(i * 7) + j] - 48;
      }
    }
    print(board);

    List<String> strs = List.empty(growable: true);
    var x = json['players'];
    String s = "$x";
    s = s.substring(1, s.length - 1);
    for(var x in s.split(",")){
      strs.add(x);
    }

    List<int> phots = List.empty(growable: true);
    var z = json['photos'];
    String l = "$z";
    l = l.substring(1, l.length - 1);
    for(var x in l.split(",")){
      phots.add(int.parse(x));
    }
    
    return Board4(
      id: id,
      players: strs,
      board: board,
      turn: json['turn'],
      winner: json['winner'],
      gameDone: json['isGameDone'],
      photos: phots
    );
  }
}
