
using Microsoft.AspNetCore.HttpOverrides;
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddSingleton<ITrack, Tracker>();
builder.Services.AddSingleton<IGameService, GameServer>();
builder.Services.AddScoped<DataContext,DataContext>(); 
builder.Services.AddSingleton<ISock, Socker>();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddMvc();

var app = builder.Build();



app.UseForwardedHeaders(new ForwardedHeadersOptions
{
    ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto
});

app.UseHttpsRedirection();
app.UseWebSockets();

app.MapControllers();

app.Run();
