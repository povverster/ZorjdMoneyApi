#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["ZorjdMoneyApi.csproj", "."]
RUN dotnet restore "./ZorjdMoneyApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ZorjdMoneyApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ZorjdMoneyApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ZorjdMoneyApi.dll"]