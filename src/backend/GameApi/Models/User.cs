
public class User {

    public User(String name, String pass, String token){
        Id = 0;
        Name = name;
        Pass = pass;
        Token = token;
        Photo = 0;
    }
    public int Id {get; set;}
    public int Photo {get;set;}
    public string Name {get; set;}
    public string Pass {get; set;}
    public string Token {get; set;}
}