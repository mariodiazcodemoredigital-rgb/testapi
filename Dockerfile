# 1. Imagen base
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# 2. SDK para compilar
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar la solución y el proyecto (basado en tu imagen de Git)
COPY TestAPI.sln ./
COPY testapi/TestAPI.csproj ./testapi/

# Restaurar paquetes
RUN dotnet restore

# Copiar el resto del código de la carpeta
COPY testapi/ ./testapi/

# Publicar el proyecto
RUN dotnet publish testapi/TestAPI.csproj -c Release -o /app/publish --no-restore

# 3. Imagen final
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .

# Configurar puerto para Easypanel (usualmente puerto 80)
ENV ASPNETCORE_URLS=http://+:80

ENTRYPOINT ["dotnet", "TestAPI.dll"]