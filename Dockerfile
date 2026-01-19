# Etapa de compilación
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar archivos .csproj y restaurar dependencias
COPY ["TestAPI.csproj", "./"]
RUN dotnet restore "TestAPI.csproj"

# Copiar el resto del código y compilar
COPY . .
RUN dotnet publish "TestAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Etapa final (Imagen ligera)
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

# Exponer el puerto que usa Easypanel por defecto
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

ENTRYPOINT ["dotnet", "testapi.dll"]