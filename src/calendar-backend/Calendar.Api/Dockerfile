#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["Calendar.Api/Calendar.Api.csproj", "Calendar.Api/"]
RUN dotnet restore "Calendar.Api/Calendar.Api.csproj"
COPY . .
WORKDIR "/src/Calendar.Api"
RUN dotnet build "Calendar.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Calendar.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
RUN apt-get update
RUN apt-get install -y curl
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Calendar.Api.dll"]