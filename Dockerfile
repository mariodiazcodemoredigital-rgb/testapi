# Etapa de compilación
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 1. Copiamos el archivo de proyecto entrando a la carpeta testapi
# El primer "testapi/" es el origen en GitHub, el "./" es el destino en Docker
COPY ["testapi/TestAPI.csproj", "./"]
RUN dotnet restore "TestAPI.csproj"

# 2. Copiamos todo el contenido de la carpeta testapi
COPY ["testapi/", "./"]

# 3. Compilamos
RUN dotnet publish "TestAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Etapa final (Imagen ligera)
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

# Exponer puerto para Easypanel
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

ENTRYPOINT ["dotnet", "TestAPI.dll"]