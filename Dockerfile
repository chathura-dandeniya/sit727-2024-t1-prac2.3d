# Use the official image as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Use SDK image to build the project
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["BestShop.csproj", "./"]
RUN dotnet restore "BestShop.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "BestShop.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "BestShop.csproj" -c Release -o /app/publish

# Final stage/image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BestShop.dll"]
