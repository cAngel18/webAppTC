# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0.101-bullseye-slim-arm64v8 AS build
WORKDIR /build

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

# copy csproj and restore as distinct layers
COPY ./*.csproj .
RUN dotnet restore

# copy everything else and build app
COPY . .
WORKDIR /build
RUN dotnet publish -c Release -o published

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0.1-bullseye-slim-arm64v8
WORKDIR /app
COPY --from=build /build/published ./
ENTRYPOINT ["dotnet", "WebAppTC.dll"]