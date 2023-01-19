using GamePlayer.Game;
using GamePlayer.MyError;
using GamePlayer.PlayableGame;
using Helpers.Result;
using Helpers.Maybe;

public class FourInARow : PlayableGame{
    public int[,] board {get;set;} = new int[0,0];
    public bool playerTurn{get;set;}
    public int id {get;set;}
    public string[] players{get;set;} = new string[0];
    public string[] playersAuths{get;set;} = new string[0];
    private int winner = -1;
    private bool valid = false;
    public string display(){
        return "";
    }
    public Maybe<MyError> fromGame(Game game){
        valid = true;
        id = game.Id;
        var board = getBoard(game.State);
        if(board is Result<int[,],MyError>.Ok boa){
            this.board = boa.Value;
        } else if(board is Result<int[,],MyError>.Error err){
            valid = false; 
            return new Maybe<MyError>.Some(err.Value);
        }
        playerTurn = game.turn == 0;
        string[] tempPlay = game.players.Split(", ");
        if(tempPlay.Length == 2) 
            players= tempPlay;
        else {
            valid = false;
            return new Maybe<MyError>.Some(new ParseError(2,"Expected 2 players got " + tempPlay.Length));
        }
        string[] tempPlayAuth = game.playersAuths.Split(", ");
        if(tempPlayAuth.Length == 2) 
            playersAuths = tempPlayAuth;
        else{
             valid = false;
             return new Maybe<MyError>.Some(new ParseError(2,"Expected 2 auth got " + tempPlayAuth.Length));
        }
        return new Maybe<MyError>.None();
    }
    private Result<int[,],MyError> getBoard(string state){
        if(state.Length != 49)
            return new Result<int[,],MyError>.Error(new ParseError(4,"Expected a size of 49"));
        int[,] board = new int[7,7];
        int i = 0;
        foreach(char ch in state.ToCharArray()){
            if(ch > 50 || ch < 48) 
                return new Result<int[,],MyError>.Error(new ParseError(1,"Expected a max value of 2"));
            board[i/7, i%7] = ch - 48;
            i++;
        }
        return new Result<int[,], MyError>.Ok(board);
    }
    public string getState(){
        char[] c= new char[49];
        for(int i = 0; i < 7;i++){
            for(int l = 0; l < 7;l++){
                c[i*7 + l] = (char) (board[i,l] + 48);
            }
        }
        return new String(c);
    }
    public int getWinner(){
        return areFourConnected();
    }
    public int areFourConnected(){
        int size = 7;
        for (int j = 0; j< size-3 ; j++ ){
            for (int i = 0; i< size; i++){
                if (this.board[i,j] != 0 && 
                    this.board[i,j+1] == this.board[i,j]  && 
                    this.board[i,j+2] == this.board[i,j] && 
                    this.board[i,j+3] == this.board[i,j]){
                    return board[i,j];
                }           
            }
        }
        for (int i = 0; i<size-3 ; i++ ){
            for (int j = 0; j<size; j++){
                if (this.board[i,j] != 0 && 
                    this.board[i+1,j] == this.board[i,j] &&
                    this.board[i+2,j] == this.board[i,j] &&
                    this.board[i+3,j] == this.board[i,j]){
                    return board[i,j];
                }           
            }
        }
        for (int i=3; i<size; i++){
            for (int j=0; j<size-3; j++){
                if (this.board[i,j] != 0 && this.board[i-1,j+1] == this.board[i,j] && this.board[i-2,j+2] == this.board[i,j] && this.board[i-3,j+3] == this.board[i,j])
                    return board[i,j];
            }
        }
        for (int i=3; i<size; i++){
            for (int j=3; j<size; j++){
                if (this.board[i,j] != 0 && this.board[i-1,j-1] == this.board[i,j] && this.board[i-2,j-2] == this.board[i,j] && this.board[i-3,j-3] == this.board[i,j])
                    return board[i,j];
            }
        }
        return -1;
    }
    public bool isGameComplete(){
        int x = getWinner();
        if(x != -1){
            winner = x;
            return true;
        }
        for(int i = 0; i < 7;i++){
            for(int l = 0; l < 7;l++){
                if(board[i,l] == 0){
                    return false;
                }
            }
        }
        return true;
    }
    public Maybe<MyError> makeMove(string move, string auth){
        int player = getPlayer(auth); 
        var x = checkTurn(auth,player);
        if(x is Maybe<MyError>.Some error){
            return error;
        }
        int place = 0;
        try{
            place = Int32.Parse(move);
        } catch (Exception){
            return new Maybe<MyError>.Some(new MoveError(3, "Move not valid"));
        }
        var mov = checkMove(place,player);
        if(mov is Maybe<MyError> err){
            return err;
        } else return new Maybe<MyError>.None();
    }
    private Maybe<MyError> checkMove(int place, int player ){
        if(isGameComplete()){
            return new Maybe<MyError>.Some(new MoveError(3,"Game is Finsishedss"));
        }
        if(place < 0 && place > 7)
            return new Maybe<MyError>.Some(new MoveError(1,"Move is not valid"));
        var move = tryMove(place,player);
        if(move is Maybe<MyError>.Some err){
            return err;
        }
        return new Maybe<MyError>.None();
    }
    private Maybe<MyError> tryMove(int place, int player){
        for(int i = 0; i < 7;i++){
            if(board[i,place] == 0){
                board[i,place] = player;
                playerTurn = !playerTurn;
                return new Maybe<MyError>.None();
            }
        }
        return new Maybe<MyError>.Some(new MoveError(9,"Row is filled"));
    }
    private Maybe<MyError> checkTurn(String auth, int player){
        if(player == -1)
            return new Maybe<MyError>.Some(new MoveError(2, "Not a Player"));
        if(playerTurn  && player == 2)
            return new Maybe<MyError>.Some(new MoveError(1, "Not player's Turn"));
        if(!playerTurn && player == 1)
            return new Maybe<MyError>.Some(new MoveError(1, "Not player's Turn"));
        return new Maybe<MyError>.None();
    }
    private int getPlayer(string auth){
        for(int i = 0; i < playersAuths.Length;i++){
            Console.WriteLine(playersAuths[i]);
            if(auth == playersAuths[i])
                return i + 1;
        }
        return -1;
    }
    public Maybe<Game> toGame(){
        if(!valid){
            return new Maybe<Game>.None();
        }
        return new Maybe<Game>.Some(
            new Game(id,2,getState(),String.Join(",",players), String.Join(", ",playersAuths),playerTurn ? 0 : 1));
    }
}