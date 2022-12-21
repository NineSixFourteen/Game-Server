namespace TestGames;
using Helpers.Maybe;
using GamePlayer.Game;
using GamePlayer.MyError;
using GamePlayer.PlayableGame;

public class ConFour{
    [Fact]
    public void TestConnect(){
        PlayableGame tic = new FourInARow();
        tic.fromGame(new Game(
           1,0, "0000000000000000000000000000000000000000000000000","player1, player2","auth1, auth2",0
        ));
        var x = tic.makeMove("0","auth1");
        Assert.Equal("1000000000000000000000000000000000000000000000000",tic.getState());
        var y = tic.makeMove("0","auth2");
        Assert.Equal("1000000200000000000000000000000000000000000000000",tic.getState());
        var z = tic.makeMove("0","auth2");
        if(z is Maybe<MyError>.Some err){
            Assert.Equal(201,err.Value.getCode());
        } else Assert.False(true);
        var r = tic.makeMove("0","rans");
        if(r is Maybe<MyError>.Some errr){
            Assert.Equal(202,errr.Value.getCode());
        } else Assert.False(true);
        tic = new FourInARow();
        tic.fromGame(new Game(
           1,0, "2000000100000010000002000000100000020000001000000","player1, player2","auth1, auth2",0
        ));
        var muv = tic.makeMove("0","auth1");
        if(muv is Maybe<MyError>.Some er){
        } else Assert.False(true);
    }
    [Fact]
    public void TestEnds(){
        PlayableGame tic = new FourInARow();
        tic.fromGame(makeGame("2222000100000010000002000000100000020000001000000"));
        Assert.True(tic.isGameComplete());
        Assert.Equal(2,tic.getWinner());
        tic = new FourInARow();
        tic.fromGame(makeGame("1221122212121112211222212211212121122121121212121"));
        Assert.True(tic.isGameComplete());
        Assert.Equal(-1,tic.getWinner());
    }
    private Game makeGame(string state){
        return new Game(1,0, state,"player1, player2","auth1, auth2",0);
    }
}