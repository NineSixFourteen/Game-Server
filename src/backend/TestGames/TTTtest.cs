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
           1,0, "000000000","player1, player2","auth1, auth2",0
        ));
        tic.makeMove("0","auth1");
        Assert.Equal("100000000",tic.getState());
        var x = tic.makeMove("1","auth1");
        MyError y;
        if(x is Maybe<MyError>.Some z){
            y = z.Value;
            Assert.Equal(201,y.getCode());
        } else Assert.False(true);
        var e = tic.makeMove("1","auth2"); 
        Assert.Equal("120000000",tic.getState());
        var err = tic.makeMove("7","rans");
        if(err is Maybe<MyError>.Some r){
            y = r.Value;
            Assert.Equal(202,y.getCode());
        } else Assert.False(true);
    }

    [Fact]
    public void checkEnd(){
        PlayableGame x = new TicTacToe();
        x.fromGame(makeTicTac("111000000"));
        Assert.True(x.isGameComplete());
        Assert.Equal(1,x.getWinner());
        x = new TicTacToe();
        x.fromGame(makeTicTac("121212212"));
        Assert.True(x.isGameComplete());
        Assert.Equal(-1,x.getWinner());
        x = new TicTacToe();
        x.fromGame(makeTicTac("200020002"));
        Assert.True(x.isGameComplete());
        Assert.Equal(2,x.getWinner());
        x = new TicTacToe();
        x.fromGame(makeTicTac("200200200"));
        Assert.True(x.isGameComplete());
        Assert.Equal(2,x.getWinner());
    }

    public Game makeTicTac(string state){
        return new Game(0,1,state,"player1, player2","auth1, auth2",0);
    }
}