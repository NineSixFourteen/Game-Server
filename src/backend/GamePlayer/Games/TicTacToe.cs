using GamePlayer.Game;
using GamePlayer.PlayableGame;
using GamePlayer.MyError;
using Helpers.Result;
using Helpers.Maybe;
using System;

public class TicTacToe : PlayableGame{
    public TicTacToe(){}
    public int[] board {get;set;} = new int[0];
    public bool playerTurn{get;set;}
    public int id {get;set;}
    public string[] players{get;set;} = new string[0];
    public string[] playersAuths{get;set;} = new string[0];
    private int winner = -1;
    private bool valid = false;
    private bool gameComplete = false;
    private Result<int[],MyError> getBoard(string state){
        if(state.Length != 9){
            return new Result<int[],MyError>.Error(new ParseError(4,"Expected a size of 9"));
        }
        int[] board = new int[9];
        int i = 0;
        foreach(char ch in state.ToList()){
            if(ch > 50 || ch < 48) {
                return new Result<int[],MyError>.Error(new ParseError(1,"Expected a max value of 2"));
            }
            board[i++] = ch - 48;
        }
        return new Result<int[], MyError>.Ok(board);
    }
    public bool isGameComplete(){
        if(!gameComplete){
            if(checkWinner()){
                gameComplete = true;
                return true;
            }
            gameComplete = !possibleMoves();
            return gameComplete;
        } else return true;
    }
    private bool possibleMoves(){
        foreach(int tile in board){
            if(tile == 0 ){
                return true;
            }
        } 
        return false;
    }
    private bool checkWinner(){
        for(int i = 0; i < 7;i += 3){
            if(board[i] != 0 && board[i] == board[i+1] && board[i+1] == board[i+2]){
                winner = board[i];
                return true;
            }
        }
        for(int i =0; i < 3;i++){
            if(board[i] != 0 && board[i] == board[i+3] && board[i+3] == board[i+6]){
                winner = board[i];
                return true;
            }
        }
        if(board[0] != 0 && board[0] == board[4] && board[4] == board[8]){
            winner = board[0];
            return true;
        }
        if(board[2] != 0 && board[2] == board[4] && board[4] == board[6]){
            winner = board[2];
            return true;
        }
        return false;
    }
    public int getWinner(){
        return winner;
    }
    public Maybe<MyError> fromGame(Game game){
        valid = true;
        id = game.Id;
        var board = getBoard(game.State);
        if(board is Result<int[],MyError>.Ok ok) 
            this.board = ok.Value;
        else if(board is Result<int[],MyError>.Error err){
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
    public Maybe<MyError> makeMove(string move, string auth){
        if(!gameComplete){
            int player = getPlayer(auth); 
            if(player == -1)
                return new Maybe<MyError>.Some(new MoveError(2, "Not a Player"));
            if(playerTurn  && player == 1)
                return new Maybe<MyError>.Some(new MoveError(1, "Not player's Turn"));
            if(!playerTurn && player == 0)
                return new Maybe<MyError>.Some(new MoveError(1, "Not player's Turn"));
            int place = 0;
            try{
                place = Int32.Parse(move);
            } catch (Exception){
                return new Maybe<MyError>.Some(new MoveError(3, "Move not valid"));
            }
            if(board[place] == 0){
                board[place] = player + 1;
                playerTurn = !playerTurn;
                return new Maybe<MyError>.None();
            } else {
                return new Maybe<MyError>.Some(new MoveError(4, "Position is filled"));
            }
        } else return new Maybe<MyError>.Some(new MoveError(4, "Game is finished"));
    }
    private int getPlayer(string auth){
        for(int i = 0; i < playersAuths.Length;i++){
            if(auth == playersAuths[i])
                return i;
        }
        return -1;
    }
    public Maybe<Game> toGame(){
        if(!valid)
            return new Maybe<Game>.None();
        return new Maybe<Game>.Some(
            new Game(id,1,getState(),String.Join(",",players), String.Join(", ",playersAuths),playerTurn ? 0 : 1));
    }
    public string getState(){
        char[] c = board.Select(val => (char) (val + 48)).ToArray();
        return new String(c);
    }
    public string display(){
        string board = "";
        for(int i = 0; i < 3;i++){
            for(int l = 0; l < 3;l++){
                board += "[" + getSym(i*3 + l) +"]";
            }
            board += '\n';
        }
        return board;
    }
    private char getSym(int n){
        switch(board[n]){
            case 1:
                return 'O';
            case 2:
                return 'X';
            default:
                return ' ';
        }
    }

}