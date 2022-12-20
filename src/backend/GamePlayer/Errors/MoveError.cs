namespace GamePlayer.MyError;

public class MoveError : MyError{

    private int code {get;}
    private string message {get;}

    public MoveError(int code, string message){
        this.code = 200 + code;
        this.message = message;
    }
    public int getCode(){
        return code;
    }
    public string getError(){
        return message;
    }
}