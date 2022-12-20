namespace GamePlayer.MyError;

public class ParseError : MyError{

    private int code {get;}
    private string message {get;}

    public ParseError(int code, string message){
        this.code = 300 + code;
        this.message = message;
    }
    public int getCode(){
        return code;
    }
    public string getError(){
        return message;
    }
}