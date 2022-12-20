namespace GamePlayer.MyError;

public class ServiceError : MyError{

    private int code {get;}
    private string message {get;}

    public ServiceError(int code, string message){
        this.code = 100 + code;
        this.message = message;
    }
    public int getCode(){
        return code;
    }
    public string getError(){
        return message;
    }
}