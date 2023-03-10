
using Microsoft.EntityFrameworkCore;
using GamePlayer.Game;

public class DataContext : DbContext{
    protected readonly IConfiguration Configuration;
    #pragma warning disable 
    public DataContext(IConfiguration configuration) => Configuration = configuration;
    
    protected override void OnConfiguring(DbContextOptionsBuilder options){
        // connect to mysql with connection string from app settings
        var connectionString = Configuration.GetConnectionString("WebApiDatabase");
        options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString));
    }

    public DbSet<User> Users { get; set;}
    public DbSet<Game> Games {get;set;}
}