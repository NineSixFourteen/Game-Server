public interface IUserService {

    bool AddUser(User user);
    IEnumerable<User> GetAllUsers();
}

public class UserService : IUserService {
    
    private IList<User> _users;

    public UserService(){
        _users = new List<User>();
        _users.Add(new User());
    }

    public bool AddUser(User user){
        if(user != null){
            _users.Add(user);
        }
        return false;
    }

    public IEnumerable<User> GetAllUsers(){
        return _users;
    }
}