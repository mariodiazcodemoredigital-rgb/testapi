# 1. Imagen base
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# 2. SDK para compilar
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# COPIAR TODO EL CONTENIDO PRIMERO
# Esto evita errores de "archivo no encontrado" si las rutas de carpetas varían
COPY . .

# RESTAURAR USANDO EL ARCHIVO DE SOLUCIÓN
# Docker buscará el archivo .sln en la raíz automáticamente
RUN dotnet restore

# PUBLICAR
# Buscamos el proyecto dentro de la subcarpeta y lo publicamos
RUN dotnet publish **/TestAPI.csproj -c Release -o /app/publish

# 3. Imagen final
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:80

ENTRYPOINT ["dotnet", "TestAPI.dll"]