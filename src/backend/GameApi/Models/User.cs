
public class User {

    public User(String name, String pass, String token){
        Id = 0;
        Name = name;
        Pass = pass;
        Token = token;
    }
    public int Id {get; set;}
    public string Name {get; set;}
    public string Pass {get; set;}
    public string Token {get; set;}
}