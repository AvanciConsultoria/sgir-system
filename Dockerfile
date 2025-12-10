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

# Install EF Core tools in SDK stage (onde o SDK existe)
RUN dotnet tool install --global dotnet-ef --version 8.0.0
ENV PATH="${PATH}:/root/.dotnet/tools"

# Create migrations bundle in build stage
WORKDIR /src
RUN dotnet ef migrations bundle --project SGIR.Infrastructure/SGIR.Infrastructure.csproj \
    --startup-project SGIR.WebApp/SGIR.WebApp.csproj \
    --output /app/publish/efbundle -r linux-x64 --self-contained || echo "Migrations bundle skipped"

# Runtime stage - Usa SDK ao invés de aspnet para ter ferramentas disponíveis
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS final
WORKDIR /app

COPY --from=publish /app/publish .

# Create entrypoint script simplificado
RUN echo '#!/bin/bash\n\
set -e\n\
echo "=== SGIR System - Starting ==="\n\
echo "Waiting for SQL Server to be ready..."\n\
for i in {1..30}; do\n\
  if timeout 1 bash -c "</dev/tcp/sqlserver/1433" 2>/dev/null; then\n\
    echo "SQL Server is ready!"\n\
    break\n\
  fi\n\
  echo "Waiting... ($i/30)"\n\
  sleep 2\n\
done\n\
echo "Starting SGIR WebApp..."\n\
exec dotnet SGIR.WebApp.dll' > /entrypoint.sh && chmod +x /entrypoint.sh

EXPOSE 80 443

ENV ASPNETCORE_URLS=http://+:80
ENV ASPNETCORE_ENVIRONMENT=Development

ENTRYPOINT ["/entrypoint.sh"]
