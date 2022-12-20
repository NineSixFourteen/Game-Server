namespace TestGames;
using Helpers.Maybe;
using GamePlayer.Game;
using GamePlayer.MyError;
using GamePlayer.PlayableGame;

public class UnitTest1{
    [Fact]
    public void TestTicTacToe(){
        PlayableGame tic = new TicTacToe();
        tic.fromGame(new Game(
            0, "000000000","player1, player2","auth1, auth2",0
        ));
        Console.WriteLine(tic.display());
        tic.makeMove("0","auth1");
        Assert.Equal("100000000",tic.getState());
        var x = tic.makeMove("1","auth1");
        MyError y;
        if(x is Maybe<MyError>.Some z){
            y = z.Value;
            Assert.Equal(y.getCode(), 201);
        } else Assert.False(true);
        var e = tic.makeMove("1","auth2"); 
        Assert.Equal("120000000",tic.getState());
        var err = tic.makeMove("7","rans");
        if(err is Maybe<MyError>.Some r){
            y = r.Value;
            Assert.Equal(y.getCode(), 202);
        } else Assert.False(true);
    }
}