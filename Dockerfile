# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj files and restore
COPY ["src/SGIR.WebApp/SGIR.WebApp.csproj", "SGIR.WebApp/"]
COPY ["src/SGIR.Infrastructure/SGIR.Infrastructure.csproj", "SGIR.Infrastructure/"]
COPY ["src/SGIR.Core/SGIR.Core.csproj", "SGIR.Core/"]

RUN dotnet restore "SGIR.WebApp/SGIR.WebApp.csproj"

# Copy everything else and build
COPY src/ .

WORKDIR "/src/SGIR.WebApp"
RUN dotnet build "SGIR.WebApp.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "SGIR.WebApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Install EF Core tools for migrations
RUN dotnet tool install --global dotnet-ef
ENV PATH="${PATH}:/root/.dotnet/tools"

COPY --from=publish /app/publish .

# Create entrypoint script
RUN echo '#!/bin/bash\n\
set -e\n\
echo "Waiting for SQL Server..."\n\
sleep 10\n\
echo "Running migrations..."\n\
dotnet ef database update --project /app/SGIR.Infrastructure.dll || true\n\
echo "Starting application..."\n\
exec dotnet SGIR.WebApp.dll' > /entrypoint.sh && chmod +x /entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
