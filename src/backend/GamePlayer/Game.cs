using System;

namespace GamePlayer.Game;
public class Game {

    public Game(){
        Id = 0;
        GameType = 0;
        State = "010101010110";
        players = "test132, test22";
        playersAuths = "auth12, auth22";
    }

    public Game(int id, int gameType,string state,string Players, string PlayersAuths,int turn ){
        Id = id;
        GameType = gameType;
        if(GameType == 1){
            State = "000000000";
        } else if(GameType == 2){
            String temp = "";
            for(int i = 0 ; i < 49;i++) temp+="0";
            State = temp;
        } else {
            State = state;
        }
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