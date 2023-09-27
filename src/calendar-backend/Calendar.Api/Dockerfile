#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["Calendar.Api/Calendar.Api.csproj", "Calendar.Api/"]
RUN dotnet restore "Calendar.Api/Calendar.Api.csproj"
COPY . .
WORKDIR "/src/Calendar.Api"
RUN dotnet publish "Calendar.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine
WORKDIR /app
EXPOSE 80
EXPOSE 443
RUN apk add --no-cache curl
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Calendar.Api.dll"]