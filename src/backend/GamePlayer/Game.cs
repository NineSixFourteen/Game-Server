﻿namespace GamePlayer.Game;
public class Game {

    //Dummy Func
    public Game(){
        Id = 0;
        GameType = 0;
        State = "010101010110";
        players = "test132, test22";
        playersAuths = "auth12, auth22";
    }
    public Game(int id, int gameType, string state, string Players, string PlayersAuths,int turn ){
        Id = id;
        GameType = gameType;
        State = state;
        players = Players;
        playersAuths = PlayersAuths;
        this.turn = turn;
    }
    public int Id {get; set;}
    public int GameType {get; set;}
    public string State {get; set;}
    public string players {get; set;}
    public string playersAuths {get; set;}
    public int turn {get; set;}
}