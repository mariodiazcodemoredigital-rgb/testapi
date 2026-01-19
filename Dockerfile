# Imagen base de .NET SDK para compilar
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copiar archivos y restaurar dependencias
COPY . ./
RUN dotnet restore

# Compilar y publicar
RUN dotnet publish -c Release -o out

# Imagen final ligera para correr la app
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .

# Puerto que usa ASP.NET por defecto
EXPOSE 80
ENTRYPOINT ["dotnet", "testapi.dll"]