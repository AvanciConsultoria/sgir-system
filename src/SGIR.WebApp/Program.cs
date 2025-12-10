using Microsoft.EntityFrameworkCore;
using System.IO;
using SGIR.Core.Interfaces;
using SGIR.Core.Services;
using SGIR.Infrastructure.Data;
using SGIR.Infrastructure.Repositories;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();

// Database Configuration with SQLite fallback for local runs
var sqlServerConnection = builder.Configuration.GetConnectionString("DefaultConnection");
var sqliteConnection = builder.Configuration.GetConnectionString("SqliteConnection");
var useSqlite = builder.Configuration.GetValue("UseSqlite", false) || string.IsNullOrWhiteSpace(sqlServerConnection);

if (useSqlite && !string.IsNullOrWhiteSpace(sqliteConnection))
{
    var dataFolder = Path.Combine(builder.Environment.ContentRootPath, "Data");
    Directory.CreateDirectory(dataFolder);
    sqliteConnection = sqliteConnection.Replace("./Data", dataFolder);
}

builder.Services.AddDbContext<SGIRDbContext>(options =>
{
    if (useSqlite && !string.IsNullOrWhiteSpace(sqliteConnection))
    {
        options.UseSqlite(sqliteConnection);
    }
    else
    {
        options.UseSqlServer(
            sqlServerConnection,
            sqlOptions => sqlOptions.EnableRetryOnFailure()
        );
    }
});

// Dependency Injection - Repositories
builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();

// Dependency Injection - Services
builder.Services.AddScoped<IAlocacaoService, AlocacaoService>();
builder.Services.AddScoped<IGapAnalysisService, GapAnalysisService>();
builder.Services.AddScoped<ICompraAutomacaoService, CompraAutomacaoService>();

// Controllers para API REST
builder.Services.AddControllers();

// Swagger para documentação da API
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new()
    {
        Title = "SGIR API",
        Version = "v1",
        Description = "Sistema de Gestão Integrada de Recursos - API REST",
        Contact = new()
        {
            Name = "Avanci Consultoria",
            Email = "favanci@hotmail.com"
        }
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "SGIR API v1");
        c.RoutePrefix = "api/docs"; // Swagger em /api/docs
    });
}
else
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();

app.MapBlazorHub();
app.MapFallbackToPage("/_Host");
app.MapControllers(); // Habilitar API REST

// Criar banco de dados e aplicar migrations automaticamente em DEV + seed básico
using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<SGIRDbContext>();

    try
    {
        await dbContext.Database.MigrateAsync();
        await SGIR.WebApp.Data.DatabaseInitializer.SeedAsync(dbContext);
        Console.WriteLine("✅ Database migrated and seeded successfully!");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"❌ Error migrating or seeding database: {ex.Message}");
    }
}

app.Run();
